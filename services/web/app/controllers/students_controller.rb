class StudentsController < ApplicationController
  before_action :set_student, only: %i[edit update destroy adjust_score]
  before_action :set_student_with_includes, only: %i[show]
  before_action :set_browser_window_id, only: :adjust_score

  # GET /students
  # GET /students.json
  def index
    @students = Student.includes(:school_class).newest_first
  end

  # GET /students/1
  # GET /students/1.json
  def show; end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit; end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        SchoolClassChannel.broadcast_to(
          @student.school_class,
          type: SchoolClassChannel::STUDENT,
          browser_window_id: params[:browser_window_id]
        )
        if params[:create_incomplete_mapping]
          @student_device_mapping =
            StudentDeviceMapping.create!(
              student: @student, school_class_id: @student.school_class_id
            )
        end
        notice =
          [
            t('.notice'),
            (t('.mapping_notice') if @student_device_mapping)
          ].compact
            .join('<br/>')

        format.html { redirect_to @student, notice: notice }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json do
          render json: @student.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        SchoolClassChannel.broadcast_to(
          @student.school_class,
          type: SchoolClassChannel::STUDENT,
          browser_window_id: params[:browser_window_id]
        )
        format.html { redirect_to @student, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json do
          render json: @student.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  def adjust_score
    lesson_id = params[:lesson_id]
    lesson =
      if lesson_id
        Lesson.find(lesson_id)
      else
        @student.school_class.most_recent_lesson
      end
    amount = params[:amount]

    question_response =
      @student.question_responses.create(
        score: amount, lesson: lesson, school_class: @student.school_class
      )

    respond_to do |format|
      if question_response.errors.empty?
        SchoolClassChannel.broadcast_to(
          @student.school_class,
          type: SchoolClassChannel::RESPONSE,
          browser_window_id: @browser_window_id
        )
        format.js do
          redirect_to edit_student_path(@student), notice: t('.success')
        end
        format.json { head :no_content }
      else
        format.js do
          redirect_to edit_student_path(@student), alert: t('.error')
        end
        format.json do
          render json: question_response.errors, status: :bad_request
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  def set_student_with_includes
    @student = Student.includes(:school_class).find(params[:id])
  end

  def set_browser_window_id
    @browser_window_id = params[:browser_window_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(
      :school_class_id,
      :name,
      :seat_row,
      :seat_col
    )
  end
end
