# frozen_string_literal: true
class AdsController < ApplicationController
  include ApplicationHelper

  before_action :set_ad, only: [:show, :edit, :update, :bump, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if user_signed_in?
      url = current_user.woeid? ? ads_woeid_path(id: current_user.woeid, type: 'give') : location_ask_path
      redirect_to url
    else
      @ads = Ad.give.available.includes(:user).paginate(page: params[:page])
    end
  end

  def show
    @comment = @ad.comments.build
    @ad.increment_readed_count!
    @comments = policy_scope(@ad.comments).includes(:user)
  end

  def new
    if current_user.woeid.nil?
      redirect_to location_ask_path
    else
      @ad = Ad.new
      @ad.comments_enabled = true
      authorize(@ad)
    end
  end

  def edit
  end

  def bump
    respond_to do |format|
      @ad.bump

      format.html { redirect_to :back, notice: t('nlt.ads.bumped') }
      format.json { head :no_content }
    end
  end

  def create
    @ad = Ad.new(ad_params)
    @ad.user_owner = current_user.id
    @ad.woeid_code = current_user.woeid
    @ad.ip = request.remote_ip
    @ad.status = 1
    @ad.published_at = Time.zone.now
    authorize(@ad)

    respond_to do |format|
      if verify_recaptcha(model: @ad) && @ad.save
        format.html { redirect_to adslug_path(@ad, slug: @ad.slug), notice: t('nlt.ads.created') }
        format.json { render action: 'show', status: :created, location: @ad }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: t('nlt.ads.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', alert: @ad.errors }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url }
      format.json { head :no_content }
    end
  end

  private

  def set_ad
    @ad = Ad.find(params[:id])
    authorize(@ad)
    @ad
  end

  def ad_params
    params.require(:ad).permit(:title, :body, :type, :status, :comments_enabled, :image)
  end
end
