class ClicksController < ApplicationController
  # TODO Authenticate API requests to create endpoint as well, e.g. via Token
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create

  before_action :set_click, only: %i[show edit update destroy]
  before_action :set_click_with_includes, only: %i[show]

  # GET /clicks
  # GET /clicks.json
  def index
    @clicks = Click.newest_first
  end

  # GET /clicks/1
  # GET /clicks/1.json
  def show; end

  # GET /clicks/new
  def new
    @click = Click.new
  end

  # GET /clicks/1/edit
  def edit; end

  # POST /clicks
  # POST /clicks.json
  def create
    c = @click = Click.new(click_params)

    respond_to do |format|
      if @click.save
        m =
          @student_device_mapping =
            update_oldest_incomplete_student_device_mapping! @click
        if !@student_device_mapping
          r = @question_response = create_question_response! @click
        end
        if @student_device_mapping
          SchoolClassChannel.broadcast_to(
            @student_device_mapping.school_class,
            type: SchoolClassChannel::MAPPING
          )
        end
        if @question_response
          SchoolClassChannel.broadcast_to(
            @question_response.school_class,
            type: SchoolClassChannel::RESPONSE
          )
        end

        format.html do
          redirect_to @click,
                      notice:
                        [
                          t('.notice'),
                          (
                            if @student_device_mapping
                              t(
                                '.mapping_notice',
                                device_id: c.device_id,
                                student_name: m.student&.name,
                                class_name: m.school_class&.name
                              )
                            end
                          ),
                          (
                            if @question_response
                              t(
                                '.response_notice',
                                student_name: r.student&.name,
                                question_name: r.question&.name,
                                class_name: r.school_class&.name,
                                lesson_name: r.lesson&.name
                              )
                            end
                          )
                        ].compact
                          .join('<br/>')
        end
        format.json { render :show, status: :created, location: @click }
      else
        format.html { render :new }
        format.json do
          render json: @click.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /clicks/1
  # PATCH/PUT /clicks/1.json
  def update
    respond_to do |format|
      if @click.update(click_params)
        format.html { redirect_to @click, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @click }
      else
        format.html { render :edit }
        format.json do
          render json: @click.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /clicks/1
  # DELETE /clicks/1.json
  def destroy
    @click.destroy
    respond_to do |format|
      format.html { redirect_to clicks_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_click
    @click = Click.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_click_with_includes
    @click = Click.includes(:question_response).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def click_params
    params.require(:click).permit(:device_id, :device_type).to_h.symbolize_keys
  end

  def update_oldest_incomplete_student_device_mapping!(click)
    return nil if StudentDeviceMapping.exists?(device_id: click.device_id)
    mapping = StudentDeviceMapping.oldest_incomplete or return nil
    mapping.update!(device_type: click.device_type, device_id: click.device_id)
    return mapping
  end

  def create_question_response!(click)
    mapping =
      StudentDeviceMapping.includes(:school_class).find_by(
        device_id: click.device_id
      ) or
      return nil

    school_class = mapping.school_class
    lesson = school_class.most_recent_lesson
    question = lesson&.most_recent_question or return nil
    return nil unless question.response_allowed
    if QuestionResponse.exists?(
         student_id: mapping.student_id, question: question
       )
      return nil
    end

    return(
      click.create_question_response!(
        student_id: mapping.student_id,
        question: question,
        lesson: lesson,
        school_class: school_class,
        score: question.score || 1
      )
    )
  end
end
