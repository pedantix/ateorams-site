class TagsController < ApplicationController
  def show
    begin 
      @tag = Tag.find(params[:id])
    rescue Exception => e
      flash[:notice] = "No tag for #{params[:id]} was found"
      redirect_to root_path
    end  
  end
end
