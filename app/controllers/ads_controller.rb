class AdsController < ApplicationController
  before_action :set_ad, only: [:show, :edit, :update, :destroy]
  before_action :get_section_locations, only: [:index]
  load_and_authorize_resource

  # GET /ads
  # GET /ads.json
  def index
    if user_signed_in? 
      if current_user.woeid?
        redirect_to ads_woeid_path(id: current_user.woeid, type: 'give')
      # or ask for the location
      else
        redirect_to location_ask_path
      end
    else
      @ads = Ad.available.includes(:user).paginate(:page => params[:page])

      # TODO: cache?
      @location = get_location_suggest

      # TODO: cache | select only id, username and ad_count
      @section_users = User.order("ads_count DESC").limit(40)
    end

  end

  # GET /ads/1
  # GET /ads/1.json
  def show
  end

  # GET /ads/new
  def new
    @ad = Ad.new
    @woeid_code = params[:woeid]
  end

  # GET /ads/1/edit
  def edit
  end

  # POST /ads
  # POST /ads.json
  def create
    @ad = Ad.new(ad_params)
    @ad.user_owner = current_user.id
    @ad.ip = request.remote_ip
    @ad.status = 1

    respond_to do |format|
      if @ad.save and verify_recaptcha(:model => @ad, :message => t('nlt.captcha_error'))
        format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ad }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ads/1
  # PATCH/PUT /ads/1.json
  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ad
    @ad = Ad.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ad_params
    params.require(:ad).permit(:title, :body, :type, :status, :woeid_code, :comments_enabled, :image, :user_owner, :ip)
  end
end
