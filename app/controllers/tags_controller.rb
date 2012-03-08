class TagsController < ApplicationController
  respond_to :html, :js
  
  def index
    query = "#{params[:search]}%"
    @tags = Tag.where("name LIKE ?", query)
    if request.xhr?
      render :partial => "tags/autocomplete_tag", :collection => @tags.take(5)
    end
  end
  
  def show
    @tag = Tag.find_by_slug(params[:id])
    @tag_posts = Post.where(:id => @tag.posts.uniq).paginate(:page => params[:page]) unless @tag.nil?
    flash[:error] = t(:record_not_found_message) if @tag.nil?
    if request.xhr?
      render :partial => "posts/post", :collection => @tag_posts
    end
  end
  
  def destroy
    post = Post.find(params[:post_id]) unless params[:post_id].blank?
    current_user.post_tags.find_all_by_tag_id(params[:id]).each(&:destroy)
    redirect_back_or root_path
  end
end
