class SessionsController < Devise::SessionsController
before_action :verify_approval!, only: :create

private
  def verify_approval!
    email = params[:admin][:email]
    unless email.nil? 
      @admin = Admin.where(email: email).first
      unless @admin.approved?
        flash[:notice] = "Account is not yet approved."
        redirect_to root_path
      end
    end    
  end
end