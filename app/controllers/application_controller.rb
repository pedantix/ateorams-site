class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?



  protected

  def configure_permitted_parameters
    [:username, :phone, :twitter_handle].each do |parameter| 
      devise_parameter_sanitizer.for(:sign_up) << parameter 
      devise_parameter_sanitizer.for(:account_update) << parameter 
    end  
  end



  def verify_approved_admin!
    if current_admin.nil? || !current_admin.approved?
      flash[:notice] = "You must be signed in to perform that action."
      redirect_to root_path
    end
  end
end
