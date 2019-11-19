class ClicksController < ApplicationController
  # TODO Authenticate API requests to create endpoint as well, e.g. via Token
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create

  before_action :set_click, only: [:show, :edit, :update, :destroy]

  # GET /clicks
  # GET /clicks.json
  def index
    @clicks = Click.all
  end

  # GET /clicks/1
  # GET /clicks/1.json
  def show
  end

  # GET /clicks/new
  def new
    @click = Click.new
  end

  # GET /clicks/1/edit
  def edit
  end

  # POST /clicks
  # POST /clicks.json
  def create
    @click = Click.new(prefix_id_with_type! click_params)

    respond_to do |format|
      if @click.save
        format.html { redirect_to @click, notice: I18n.t('.notice') }
        format.json { render :show, status: :created, location: @click }
      else
        format.html { render :new }
        format.json { render json: @click.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clicks/1
  # PATCH/PUT /clicks/1.json
  def update
    respond_to do |format|
      if @click.update(click_params)
        format.html { redirect_to @click, notice: I18n.t('.notice') }
        format.json { render :show, status: :ok, location: @click }
      else
        format.html { render :edit }
        format.json { render json: @click.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clicks/1
  # DELETE /clicks/1.json
  def destroy
    @click.destroy
    respond_to do |format|
      format.html { redirect_to clicks_url, notice: I18n.t('.notice') }
      format.json { head :no_content }
    end
  end

  private

  def prefix_id_with_type!(params)
    prefix = "#{params[:device_type]}:"
    id = params[:device_id] || ''
    params[:device_id] = "#{prefix}#{id}" if not id.start_with? prefix
    params
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_click
      @click = Click.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def click_params
      params.require(:click).permit(:device_id, :device_type)
    end
end
