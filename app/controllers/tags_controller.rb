class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    @tags = current_user.posts.map { |post| post.tags }.flatten.uniq
    @show_untag_all = true
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  end
  
  def untag_all
    @tag = Tag.find(params[:id])
    flash.now[:error] = @tag.posts.count
    @tag.posts.each do |post|
      post.tags.find(@tag.id).destroy
    end
  end
end
