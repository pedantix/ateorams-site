class BlogsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).per(25)
  end

  def show
    @post = Post.find(params[:id])
  end

end
