class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @post = current_user.posts.build(:title => params[:post][:title], :content => params[:post][:content])
    if @post.save
      @post.tag_with_list(params[:post][:tag_list], current_user)
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
    if post.update_attributes(:title => params[:post][:title], :content => params[:post][:content])
      post.tag_with_list(params[:post][:tag_list], current_user)
      redirect_to root_path
    else
      render 'post/edit'
    end
  end
  
  def destroy
    # tag_ids = @post.tag_ids # save tag ids for a destroy check later
    @post.destroy
    # tags = Tag.find(tag_ids)
    # tags.each do |tag|
      # tag.destroy if tag.posts.empty? # destroy unused tags to keep the database neat
    # end
    redirect_back_or root_path
  end
  
  private
    def authorized_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path if @post.nil?
    end
end
