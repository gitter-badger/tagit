class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    @tags = current_user.tags
  end
  
  def show
  end
  
	def new
    @tag = Tag.new
	end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
end
