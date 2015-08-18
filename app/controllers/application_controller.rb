class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Localization

  before_action :authenticate_user!, unless: -> { user_signed_in? }
  helper_method :administrator_signed_in?, :current_administrator

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to backlink, alert: exception.message }
      format.js   { render partial: 'shared/access_denied', locals: { exception: exception } }
      format.json { render json: { error: exception.message }, status: 403 }
    end
  end if defined?(CanCan)


  # redirect back to current page after successful sign in
  def after_sign_in_path_for(resource)
    return stored_location_for(resource) || case
        when resource.has_role?(:administrator)
          sign_in :administrator, resource
          admin_root_path
        else
          root_path
      end
  end

  protected

  def authenticate_administrator!
    if authenticate_user! && current_user.has_role?(:administrator)
      current_user
    else
      sign_out :user
      redirect_to admin_root_path
    end
  end

  def administrator_signed_in?
    current_user && current_user.has_role?(:administrator)
  end

  def current_administrator
    current_user if administrator_signed_in?
  end

  def backlink
    user_signed_in? ? after_sign_in_path_for(current_user) : (request.referer || root_path)
  end

end
