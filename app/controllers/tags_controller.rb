class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    @tags = current_user.posts.map { |p| p.tags }.flatten.uniq
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  end
end
