class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to root_path
    else
      @stream = []
      render 'pages/home'
    end
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    post = Post.find(params[:id])
    if post.update_attributes(params[:post])
      redirect_to root_path
    else
      render 'post/edit'
    end
  end
  
  def destroy
    tag_ids = @post.tags.map{ |tag| tag.id } # save tag ids for a destroy check later
    @post.destroy
    
    tags = Tag.find(tag_ids)
    tags.each do |tag|
      if tag.posts.empty? # destroy unused tags to keep the database neat
        tag.destroy
      end
    end
    redirect_back_or root_path
  end
  
  private
    def authorized_user
      @post = current_user.posts.find(params[:id])
    rescue
      redirect_to root_path
    end
end
