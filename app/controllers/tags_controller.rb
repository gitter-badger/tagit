class TagsController < ApplicationController
	def index
    @title = t(:tag).pluralize
    if current_user.nil?
      @tags = Tag.all
    else
      @tags = current_user.posts.map{ |post| post.tags }.flatten.uniq
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
  end
  
  def destroy
    tag = Tag.find(params[:id])
    if params[:untag] == 'all'
      tag.posts.delete_all # this only deletes the posts_tags relations, not the actual posts
      redirect_back_or tags_path
    elsif params[:untag] == 'post'
      post = Post.find(params[:post_id])
      tag.posts.delete(post) # this only deletes the posts_tags relation, not the actual post
      redirect_back_or root_path
    end
    
    if tag.posts.empty? # destroy unused tags to keep the database neat
      tag.destroy
    end
  end
end
