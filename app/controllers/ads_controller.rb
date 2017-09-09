# frozen_string_literal: true

class AdsController < ApplicationController
  include StringUtils

  before_action :set_ad, except: %i[new create index]
  before_action :authenticate_user!, except: %i[index show]

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
    @ad.status = :available if @ad.give?
    @ad.published_at = Time.zone.now
    authorize(@ad)

    if verify_recaptcha(model: @ad) && @ad.save
      @ad.check_spam!

      redirect_to ad_friendly_path, notice: t('nlt.ads.created')
    else
      render 'new'
    end
  end

  def show
    if @ad.slug != params[:slug]
      redirect_to adslug_path(@ad, slug: @ad.slug), status: :moved_permanently
    else
      @comment = @ad.comments.build
      @ad.increment_readed_count!
      @comments = policy_scope(@ad.comments).includes(:user).oldest_first
    end

    @author = @ad.user
  end

  def edit
    session[:return_to] = referer_path
  end

  def change_status
    @ad.update!(status: params[:status].to_sym)

    redirect_back fallback_location: profile_path(@ad.user.username),
                  notice: t('nlt.ads.marked_as', status: @ad.status_string)
  end

  def bump
    @ad.bump

    redirect_back fallback_location: profile_path(@ad.user.username),
                  notice: t('nlt.ads.bumped')
  end

  def update
    if @ad.update(ad_params)
      @ad.check_spam!

      redirect_to update_redirect_path, notice: t('nlt.ads.updated')
    else
      render 'edit', alert: @ad.errors
    end
  end

  def destroy
    @ad.destroy

    redirect_to destroy_redirect_path, notice: t('nlt.ads.destroyed')
  end

  private

  def update_redirect_path
    session.delete(:return_to) || ad_friendly_path
  end

  def destroy_redirect_path
    previous_path = session.delete(:return_to)
    unless previous_path.nil? || previous_path == ad_friendly_path
      return previous_path
    end

    profile_path(@ad.user.username)
  end

  def ad_friendly_path
    adslug_path(@ad, slug: @ad.slug)
  end

  def referer_path
    URI(request.referer).path
  rescue
    ad_friendly_path
  end

  def set_ad
    @ad = Ad.find(params[:id])
    authorize(@ad)
    @ad
  end

  def ad_create_whitelist
    ad_update_whitelist + [:type]
  end

  def ad_update_whitelist
    %i[title body comments_enabled image]
  end

  def ad_params
    params.require(:ad).permit(send(:"ad_#{params[:action]}_whitelist"))
  end
end
