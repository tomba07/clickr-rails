class QuestionsController < ApplicationController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_question_with_includes, only: [:show]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.includes(:school_class, :lesson).all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    clazz = SchoolClass.find_by_id(question_params[:school_class_id]) || current_user.school_class
    lesson_id = question_params[:lesson_id] || clazz&.most_recent_lesson_or_create&.id
    @question = Question.new({ school_class_id: clazz&.id, lesson_id: lesson_id, **question_params })

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: t('.notice') }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: t('.notice') }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
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
      params.require(:question).permit(:school_class_id, :lesson_id, :name).reject{|_, v| v.blank?}.to_h.symbolize_keys
    end
end
