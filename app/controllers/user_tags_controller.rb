class UserTagsController < ApplicationController
  before_filter :authenticate
  
  respond_to :html, :js
  
  def create
    @tag = Tag.find(params[:user_tag][:tag_id])
    current_user.follow_tag!(@tag)
    respond_with @tag
  end

  def destroy
    @tag = UserTag.find(params[:id]).tag
    current_user.unfollow_tag!(@tag)
    respond_with @tag
  end
end
