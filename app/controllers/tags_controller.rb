class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    if current_user.nil?
      @tags = Tag.all # Post.all.map{ |post| post.tags }.flatten.uniq
      @show_untag_all = false
    else
      @tags = current_user.posts.map{ |post| post.tags }.flatten.uniq
      @show_untag_all = true
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
    @show_untag_all = true
  end
  
  def destroy # unused tags remain for now; they could actually be periodically destroyed at some point
    tag = Tag.find(params[:id])
    tag.posts.delete_all # this only deletes the posts_tags relations, not the actual posts
    redirect_back_or tags_path
  end
end
