class BlogsController < ApplicationController
before_action :set_post, only: [:edit, :show, :update]
  def index
    @posts = Post.page(params[:page]).per(25)
  end

  def show
  end

  def new
    @post = Post.new
  end


  def create
    begin
      @post = Post.create!(blog_params)
      @post.admins << current_admin
      flash[:success] = "Post Successfully added."
      redirect_to blog_path(@post)
    rescue Exception => e
      @post = Post.new(blog_params)
      flash.now[:error] = "There was an error creating your post."
      render 'new'
    end
  end

  def edit
  end

  def update
    begin
      @post.update_attributes!(blog_params)
      flash[:success] = "Post Successfully updated."
      redirect_to blog_path(@post)      
    rescue Exception => e
      @post = Post.new(blog_params)
      flash.now[:error] = "There was an error updating your post."
      render 'edit'
    end
  end

private 
  def blog_params
    params.require(:post).permit(:title, :tags_text, :body)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
