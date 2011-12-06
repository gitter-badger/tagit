class TagsController < ApplicationController
  respond_to :html, :js
  
	def index
    @title = t(:tag).pluralize
    if current_user.nil?
      @tags = Tag.all
    else
      @tags = current_user.tags
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  end
  
  def destroy
    tag = Tag.find(params[:id])
    
    if current_user.tags.include?(tag) # prevent a user from deleting foreign posts-tags
      if params[:untag] == 'all'
        current_user.posts.each do |post|
          post.tags.delete(tag) # this only deletes the posts-tags relations, not the actual posts
        end
        redirect_back_or tags_path
      elsif params[:untag] == 'post'
        post = current_user.posts.find(params[:post_id])
        tag.posts.delete(post) # this only deletes the posts-tags relation, not the actual post
      end
    end
    
    if tag.posts.empty? # destroy unused tags to keep the database neat
      tag.destroy
    end
  end
end
