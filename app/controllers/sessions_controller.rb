class SessionsController < Devise::SessionsController
before_action :verify_approval!, only: :create

private
  def verify_approval!
    begin # leaned down and now rescueing from exception, thanks Eugene
      email = params[:admin][:email]
      @admin = Admin.where(email: email).first
      if  !@admin.approved?
        flash[:notice] = "Account is not yet approved."
        redirect_to root_path
      end
    rescue Exception => e 
      flash[:notice] = "Account does not exist."
      redirect_to root_path
    end   
  end
end