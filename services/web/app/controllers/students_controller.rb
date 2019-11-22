class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]
  before_action :set_student_with_includes, only: [:show]

  # GET /students
  # GET /students.json
  def index
    @students = Student.includes(:school_class).all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        @student_device_mapping = StudentDeviceMapping.create!(student: @student, school_class_id: @student.school_class_id) if params.dig(:student, :create_incomplete_mapping)
        notice = [
          t('.notice'),
          (t('.mapping_notice') if @student_device_mapping),
        ].compact.join('<br/>')

        redirect_back fallback_location: student_path(@student), notice: notice and return if params.dig(:student, :redirect_back)

        format.html { redirect_to @student, notice: notice }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    def set_student_with_includes
      @student = Student.includes(:school_class).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:school_class_id, :name, :seat_row, :seat_col)
    end
end
