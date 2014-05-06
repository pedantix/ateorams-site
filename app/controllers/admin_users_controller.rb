class AdminUsersController < ApplicationController
before_action :filter_site_admin!
before_action :set_admin!, only: [:edit, :update]
  def index
    @unapproved_admins = Admin.unapproved_admins
    @approved_admins = Admin.approved_admins
    @site_admins = Admin.site_admins

  end

  def update
    begin
      @admin.update_attributes!(admin_privilege_params)
      flash[:success] = "User privileges updated successfully."
      redirect_to admin_users_path
    rescue Exception => e
      flash.now[:error] = "There was an error in the admin privileges form."
      render 'edit'
    end
  end

  def edit

  end

private
  def filter_site_admin!
    case 
    when current_admin.nil? 
      flash[:notice] = "You must be signed in to perform that action."
      redirect_to root_path
    when !current_admin.site_admin?
      flash[:notice] = "You must be a site admin to perform that action."
      redirect_to root_path
    when current_admin.site_admin?

    else
      flash[:notice] = "You must be a site admin to perform that action."
      redirect_to root_path
    end
  end

  def set_admin!
    @admin = Admin.find(params[:id])
  end


  def admin_privilege_params
    params.require(:admin).permit(:approved, :site_admin)
  end
end


