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
    @click = Click.new(click_params)

    respond_to do |format|
      if @click.save
        Rails.logger.info "Click registered: #{@click.device_id}"
        @mapping =
          Clickr::Task::UpdateOldestIncompleteMapping.call(@click).result
        @responses = Clickr::Task::CreateQuestionResponses.call(@click).result

        if @mapping
          SchoolClassChannel.broadcast_to(
            @mapping.school_class,
            type: SchoolClassChannel::MAPPING
          )
        end
        @responses.each do |response|
          SchoolClassChannel.broadcast_to(
            response.school_class,
            type: SchoolClassChannel::RESPONSE
          )
        end

        format.html { redirect_to @click, notice: t('.notice') }
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
end
