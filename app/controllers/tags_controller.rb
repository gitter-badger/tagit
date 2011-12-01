class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    @tags = current_user.posts.map { |p| p.tags }.flatten.uniq
    # @tags = current_user.posts.last.tags
    # @tags = Tag.all
  end
  
  def show
  end
  
	def new
    @tag = Tag.new
	end
  
  def create
    @tag = Tag.new(params[:name])
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
end
