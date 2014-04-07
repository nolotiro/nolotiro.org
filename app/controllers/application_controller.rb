class ApplicationController < ActionController::Base
  # TODO: comment captcha for ad creation/edition
  # TODO: on first login show notice of what is nolotiro.org  
  # TODO: add meta description 'nolotiro.org is a website where you can give away things you no longer want or no longer need to pick them up other people who may serve or be of much use. '
  # FIXME: extra_meta in RSS 
  # FIXME: extra languages helper meta
  # FIXME: after login whould say "Welcome, USERNAME "
  #
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # bug cancan rails 4 ForbbidenAttributesError
  # https://github.com/ryanb/cancan/issues/835
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in? 
      redirect_to root_url, :alert => t('nlt.permission_denied')
    else
      redirect_to new_user_session_url, :alert => exception.message
    end
  end

  # after a user sing ins
  def after_sign_in_path_for(resource)
    # go to their location if they have one
    if current_user.woeid?
      ads_woeid_path(id: current_user.woeid, type: 'give')
    else
    # or ask for the location
      location_ask_path
    end
  end
   
  def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  private

  def get_location_suggest 
    ip_address = GeoHelper.get_ip_address request
    GeoHelper.suggest ip_address
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
  end


end
