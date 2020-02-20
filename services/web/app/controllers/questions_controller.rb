class QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy stop]
  before_action :set_question_with_includes, only: %i[show]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.includes(:school_class, :lesson).newest_first
  end

  # GET /questions/1
  # GET /questions/1.json
  def show; end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit; end

  # POST /questions
  # POST /questions.json
  def create
    # find_by_id does not raise exception if ID does not exist
    school_class =
      SchoolClass.find_by_id(question_params[:school_class_id]) ||
        CurrentSchoolClass.get
    lesson_id =
      question_params[:lesson_id] ||
        school_class&.most_recent_lesson_or_create&.id
    @question =
      Question.new(
        {
          school_class_id: school_class&.id,
          lesson_id: lesson_id,
          **question_params
        }
      )

    respond_to do |format|
      if @question.save
        SchoolClassChannel.broadcast_to(
          @question.school_class,
          type: SchoolClassChannel::QUESTION,
          browser_window_id: params[:browser_window_id]
        )

        if params[:redirect_back]
          redirect_back fallback_location: question_path(@question),
                        notice: t('.notice') and
            return
        end
        format.html { redirect_to @question, notice: t('.notice') }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json do
          render json: @question.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        SchoolClassChannel.broadcast_to(
          @question.school_class,
          type: SchoolClassChannel::QUESTION,
          browser_window_id: params[:browser_window_id]
        )

        format.html { redirect_to @question, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json do
          render json: @question.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  def stop
    respond_to do |format|
      if @question.update(response_allowed: false)
        SchoolClassChannel.broadcast_to(
          @question.school_class,
          type: SchoolClassChannel::QUESTION,
          browser_window_id: params[:browser_window_id]
        )

        if params[:redirect_back]
          redirect_back fallback_location: question_path(@question),
                        notice: t('.notice') and
            return
        end
        format.html { render :show, status: :ok, location: @question }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json do
          render json: @question.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  def set_question_with_includes
    @question = Question.includes(:school_class, :lesson).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    # Remove blank values to allow merge
    params.require(:question).permit(
      :school_class_id,
      :lesson_id,
      :name,
      :score
    )
      .reject { |_, v| v.blank? }.to_h
      .symbolize_keys
  end
end
