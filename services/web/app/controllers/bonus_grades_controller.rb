class BonusGradesController < ApplicationController
  before_action :set_bonus_grade, only: %i[show edit update destroy]

  # GET /bonus_grades
  # GET /bonus_grades.json
  def index
    @bonus_grades = BonusGrade.includes(:student, :school_class).newest_first
  end

  # GET /bonus_grades/1
  # GET /bonus_grades/1.json
  def show; end

  # GET /bonus_grades/new
  def new
    session[:redirect_to] = params[:redirect_to]
    student = Student.find_by(id: params[:student_id])
    school_class = student&.school_class
    @bonus_grade =
      BonusGrade.new(
        student: student, school_class: school_class, percentage: 1.0
      )
  end

  # GET /bonus_grades/1/edit
  def edit; end

  # POST /bonus_grades
  # POST /bonus_grades.json
  def create
    @bonus_grade = BonusGrade.new(bonus_grade_params)

    respond_to do |format|
      if @bonus_grade.save
        redirect_url =
          if session.delete(:redirect_to) == 'lesson_execution'
            root_path
          else
            @bonus_grade
          end
        format.html { redirect_to redirect_url, notice: t('.create.notice') }
        format.json { render :show, status: :created, location: @bonus_grade }
      else
        format.html { render :new }
        format.json do
          render json: @bonus_grade.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /bonus_grades/1
  # PATCH/PUT /bonus_grades/1.json
  def update
    respond_to do |format|
      if @bonus_grade.update(bonus_grade_params)
        format.html { redirect_to @bonus_grade, notice: t('.update.notice') }
        format.json { render :show, status: :ok, location: @bonus_grade }
      else
        format.html { render :edit }
        format.json do
          render json: @bonus_grade.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /bonus_grades/1
  # DELETE /bonus_grades/1.json
  def destroy
    @bonus_grade.destroy
    respond_to do |format|
      format.html { redirect_to bonus_grades_url, notice: t('.destroy.notice') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bonus_grade
    @bonus_grade = BonusGrade.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bonus_grade_params
    params.require(:bonus_grade).permit(
      :student_id,
      :school_class_id,
      :percentage
    )
  end
end
