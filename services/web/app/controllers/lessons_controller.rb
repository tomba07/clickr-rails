class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[edit update destroy]
  before_action :set_lesson_with_includes, only: %i[show]

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = Lesson.includes(:school_class).newest_first
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show; end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit; end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson =
      Lesson.new(
        { school_class_id: CurrentSchoolClass.get&.id, **lesson_params }
      )

    respond_to do |format|
      if @lesson.save
        SchoolClassChannel.broadcast_to(
          @lesson.school_class,
          type: SchoolClassChannel::LESSON,
          browser_window_id: params[:browser_window_id]
        )
        if params[:redirect_back]
          redirect_back fallback_location: lesson_path(@lesson),
                        notice: t('.notice') and return
        end

        format.html { redirect_to @lesson, notice: t('.notice') }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json do
          render json: @lesson.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json do
          render json: @lesson.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html {
        if params[:redirect_back]
          redirect_back fallback_location: lessons_url, notice: t('.notice')
        else
          redirect_to lessons_url, notice: t('.notice')
        end
      }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def set_lesson_with_includes
    @lesson = Lesson.includes(:school_class).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit(:name, :school_class_id).reject do |_, v|
      v.blank?
    end.to_h.symbolize_keys
  end
end
