class AdminUsersController < ApplicationController
before_action :filter_site_admin!

  def index
    @unapproved_admins = Admin.where(approved: false)
  end

  def update
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
end


