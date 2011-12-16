class TagsController < ApplicationController
  # class PostForbidden < StandardError
  # end
  
  def show
    @tag = Tag.find_by_id(params[:id])
    flash[:error] = t(:record_not_found_message) and return if @tag.nil?
    # @posts = @tag.posts
  end
  
  def destroy
    # @post = Post.find(params[:post_id]) unless params[:post_id].blank?
    # tag = Tag.find(params[:id])    
    
    # if params[:untag] == "all"
      # current_user.posts.each do |post|
        # post.tags.delete(tag) # this only deletes the posts-tags relations, not the actual posts
      # end
      # redirect_back_or tags_path
    # elsif params[:untag] == "post"
      # @post.untag!(tag, current_user)
    # end
    
    # tag.destroy if tag.posts.empty? # destroy unused tags to keep the database neat
  # rescue ActiveRecord::RecordNotFound
    # flash[:error] = t(:record_not_found_message)
  # rescue PostForbidden
    # flash[:error] = t(:no_access_message)
  # rescue TagNotDeleted
    # flash[:error] = t(:post_untag_failed_message) % { :tag => tag.name }
  # rescue
    # respond_with @post
  end
end
