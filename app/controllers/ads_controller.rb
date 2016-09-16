# frozen_string_literal: true

class AdsController < ApplicationController
  include StringUtils

  before_action :set_ad, except: [:new, :create, :index]
  before_action :authenticate_user!, except: [:index, :show]

  def new
    if current_user.woeid.nil?
      redirect_to location_ask_path
    else
      @ad = Ad.new(comments_enabled: true)
      authorize(@ad)
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

    if verify_recaptcha(model: @ad) && @ad.save
      @ad.check_spam!

      redirect_to redirect_path, notice: t('nlt.ads.created')
    else
      render action: 'new'
    end
  end

  def show
    @comment = @ad.comments.build
    @ad.increment_readed_count!
    @comments = policy_scope(@ad.comments).includes(:user)
  end

  def edit
  end

  def bump
    @ad.bump

    redirect_to :back, notice: t('nlt.ads.bumped')
  end

  def update
    if @ad.update(ad_params)
      @ad.check_spam!

      redirect_to redirect_path, notice: t('nlt.ads.updated')
    else
      render action: 'edit', alert: @ad.errors
    end
  end

  def destroy
    @ad.destroy

    redirect_to ads_url
  end

  private

  def redirect_path
    return ads_woeid_path(current_user.woeid, type: 'give') if @ad.spam

    adslug_path(@ad, slug: @ad.slug)
  end

  def set_ad
    @ad = Ad.find(params[:id])
    authorize(@ad)
    @ad
  end

  def ad_params
    params.require(:ad).permit(:title, :body, :type, :status, :comments_enabled, :image)
  end
end
