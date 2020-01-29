class StudentDeviceMappingsController < ApplicationController
  before_action :set_student_device_mapping, only: %i[edit update destroy]
  before_action :set_student_device_mapping_with_includes, only: %i[show]

  # GET /student_device_mappings
  # GET /student_device_mappings.json
  def index
    @student_device_mappings =
      StudentDeviceMapping.includes(:student, :school_class).newest_first
  end

  # GET /student_device_mappings/1
  # GET /student_device_mappings/1.json
  def show; end

  # GET /student_device_mappings/new
  def new
    @student_device_mapping = StudentDeviceMapping.new
  end

  # GET /student_device_mappings/1/edit
  def edit; end

  # POST /student_device_mappings
  # POST /student_device_mappings.json
  def create
    @student_device_mapping =
      StudentDeviceMapping.new(student_device_mapping_params)
    # TODO set missing data

    respond_to do |format|
      if @student_device_mapping.save
        format.html do
          redirect_to @student_device_mapping, notice: t('.notice')
        end
        format.json do
          render :show, status: :created, location: @student_device_mapping
        end
      else
        format.html { render :new }
        format.json do
          render json: @student_device_mapping.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /student_device_mappings/1
  # PATCH/PUT /student_device_mappings/1.json
  def update
    respond_to do |format|
      if @student_device_mapping.update(student_device_mapping_params)
        format.html do
          redirect_to @student_device_mapping, notice: t('.notice')
        end
        format.json do
          render :show, status: :ok, location: @student_device_mapping
        end
      else
        format.html { render :edit }
        format.json do
          render json: @student_device_mapping.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /student_device_mappings/1
  # DELETE /student_device_mappings/1.json
  def destroy
    @student_device_mapping.destroy
    respond_to do |format|
      format.html do
        redirect_to student_device_mappings_url, notice: t('.notice')
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student_device_mapping
    @student_device_mapping = StudentDeviceMapping.find(params[:id])
  end

  def set_student_device_mapping_with_includes
    @student_device_mapping =
      StudentDeviceMapping.includes(:student, :school_class).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_device_mapping_params
    params.require(:student_device_mapping).permit(
      :student_id,
      :school_class_id,
      :device_id,
      :device_type
    )
  end
end
