class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    if current_user.nil?
      @tags = Tag.all # Post.all.map{ |post| post.tags }.flatten.uniq
    else
      @tags = current_user.posts.map{ |post| post.tags }.flatten.uniq
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  end
  
  def destroy # unused tags remain for now; they could actually be periodically destroyed at some point
    if params[:untag] == 'all'
      tag = Tag.find(params[:id])
      tag.posts.delete_all # this only deletes the posts_tags relations, not the actual posts
      redirect_back_or tags_path
    elsif params[:untag] == 'post'
      tag = Tag.find(params[:id])
      post = Post.find(params[:post_id])
      tag.posts.delete(post) # this only deletes the posts_tags relation, not the actual post
      redirect_back_or root_path
    end
  end
end
