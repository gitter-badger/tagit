class PostTagsController < ApplicationController
  respond_to :html, :js
  
  def create
    # flash[:notice] = params.map{ |p| p.to_s }.join(", ")
    # redirect_to root_path
    
    @post = Post.find(params[:post_id])
    @tag = Tag.find(params[:tag_id])
    @post.tag!(@tag, current_user)
    respond_with @post, @tag
  end
  
  def destroy
    post_tag = PostTag.find_by_id(params[:id])
    if post_tag.nil?
      flash[:error] = t(:record_not_found_message)
      return
    end
    @post = post_tag.post
    @tag = post_tag.tag
    post_tag.destroy
    respond_with @post, @tag
  end
end
