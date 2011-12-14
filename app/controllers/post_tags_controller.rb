class PostTagsController < ApplicationController
  respond_to :html, :js
  
  def create
    post = Post.find(params[:post_tag][:post_id])
    tag = Tag.find(params[:post_tag][:tag_id])
    post.tag!(tag, current_user)
    # respond_with @post, @tag
  end
  
  def destroy
    post = Post.find(params[:post_id])
    tag = PostTag.find(params[:id]).tag
    post.untag!(tag, current_user)
    # # respond_with @post, @tag
  end
end
