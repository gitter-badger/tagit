class TagsController < ApplicationController
  class PostForbidden < StandardError
  end
  
  class TagNotDeleted < StandardError
  end
  
  respond_to :html, :js
  
	def index
    @title = t(:tag).pluralize
    @tags = current_user.nil? ? Tag.all : current_user.tags_from_posts
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(:record_not_found_message)
  end
  
  def destroy
    @post = Post.find(params[:post_id]) unless params[:post_id].blank?
    tag = Tag.find(params[:id])    
    
    if params[:untag] == "all"
      current_user.posts.each do |post|
        post.tags.delete(tag) # this only deletes the posts-tags relations, not the actual posts
      end
      redirect_back_or tags_path
    elsif params[:untag] == "post"
      raise PostForbidden if !current_user.tags.include?(tag)
      tag.posts.delete(@post) # this only deletes the posts-tags relation, not the actual post
      raise TagNotDeleted if tag.posts.include?(@post) # check if delete was successfull
    end
    
    tag.destroy if tag.posts.empty? # destroy unused tags to keep the database neat
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(:record_not_found_message)
  rescue PostForbidden
    flash[:error] = t(:no_access_message)
  rescue TagNotDeleted
    flash[:error] = t(:post_untag_failed_message) % { :tag => tag.name }
  rescue
    respond_with @post
  end
end
