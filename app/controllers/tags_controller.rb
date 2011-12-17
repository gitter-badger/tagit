class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_id(params[:id])
    flash[:error] = t(:record_not_found_message) and return if @tag.nil?
  end
  
  def destroy
    post = Post.find(params[:post_id]) unless params[:post_id].blank?
    current_user.post_tags.find_all_by_tag_id(params[:id]).each(&:destroy)
    redirect_back_or root_path
  end
end
