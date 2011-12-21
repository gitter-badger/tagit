class UserTagsController < ApplicationController
  respond_to :html, :js
  
  def create
    @tag = Tag.find_by_id(params[:user_tag][:tag_id])
    current_user.follow_tag!(@tag)
    @stream = current_user.stream.paginate(:page => params[:page])
    respond_with @tag, @stream
  end
  
  def destroy
    @tag = UserTag.find_by_id(params[:id]).tag
    current_user.unfollow_tag!(@tag)
    @stream = current_user.stream.paginate(:page => params[:page])
    respond_with @tag, @stream
  end
end
