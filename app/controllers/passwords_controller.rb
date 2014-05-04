class PasswordsController < Devise::PasswordsController
before_action :verify_approval!, only: :update

private
  def verify_approval!
    token =  params[:admin][:reset_password_token]
    unless token.nil? 
      admin = Admin.where(reset_password_token: digest_admin_token(token)).first
      unless admin.approved?
        flash[:notice] = "Account is not yet approved."
        redirect_to root_path
      end
    end    
  end

  def digest_admin_token(token)
    Devise.token_generator.digest(Admin, :reset_password_token, token)
  end
end