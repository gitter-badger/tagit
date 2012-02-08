class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  respond_to :html, :js
  
  def create
    @post = current_user.posts.build(:title => params[:post][:title], :content => params[:post][:content])
    if @post.save
      @post.tag_with_list(params[:post][:tag_list], current_user)
      respond_with @post
    else
      if @post.valid?
        flash[:error] = t(:post_failed_message)
      else
        flash[:error] = @post.errors.full_messages
      end
      @post = nil
      respond_with @post
    end
  end
  
  def show
    @post = Post.find_by_id(params[:id])
  end
  
  def edit
    @post = Post.find_by_id(params[:id])
    respond_with @post
  end
  
  def update
    @post = Post.find_by_id(params[:id])
    if @post.update_attributes(:title => params[:post][:title], :content => params[:post][:content])
      @post.tag_with_list(params[:post][:tag_list], current_user)
      respond_with @post
    else
      if @post.valid?
        flash[:error] = t(:post_failed_message)
      else
        flash[:error] = @post.errors.full_messages
      end
      @post = nil
      respond_with @post
    end
  end
  
  def destroy
    @post_id = @post.id
    @post.destroy
    respond_with @post_id
  end
  
  private
    def authorized_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path if @post.nil?
    end
end
