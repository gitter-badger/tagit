class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  respond_to :html, :js
  
  def create
    if params[:commit] == t(:post_verb) #Create new post
      @post = current_user.posts.build(:title => params[:post][:title], :content => params[:post][:content])
      if @post.save
        @post.tag_with_list(params[:post][:tag_list], current_user)
        respond_with @post
      else
        if @post.valid?
          flash[:error] = t(:post_failed_message)
        else
          flash[:error] = @post.errors.full_messages
        end
        @post = nil
        respond_with @post
      end
    elsif params[:commit] == t(:search_verb) #Search stream
      if params[:post][:title].blank? && params[:post][:content].blank? && params[:post][:tag_list].blank? #No search parameters - reset to default
        @stream = current_user.stream.paginate(:page => params[:page])
      else
        title = "%#{params[:post][:title]}%";
        content = "%#{params[:post][:content]}%";
        tag_names = params[:post][:tag_list].split(/,\s*/).map{|name| name.downcase}
        if tag_names.blank?
          @stream = current_user.stream
            .where('LOWER("posts".title) LIKE LOWER(?) AND LOWER("posts".content) LIKE LOWER(?)', title, content)
            .paginate(:page => params[:page])
        else
          tag_ids = Tag.select('id').where('LOWER(name) in (?)', tag_names)
          if tag_ids.blank?
            @stream = []
          else
            @stream = current_user.stream
              .where('
                LOWER("posts".title) LIKE LOWER(?) AND
                LOWER("posts".content) LIKE LOWER(?) AND
                (SELECT COUNT(DISTINCT "post_tags".tag_id)
                FROM "post_tags"
                WHERE "post_tags".post_id = "posts".id AND "post_tags".tag_id IN (?)) = ?', title, content, tag_ids, tag_ids.length)
              .paginate(:page => params[:page])
          end
        end
      end
      flash[:error] = t(:no_results_found_message) if @stream.blank?
      respond_with @stream
    end
  end
  
  def show
    @post = Post.find_by_id(params[:id])
  end
  
  def edit
    @post = Post.find_by_id(params[:id])
    respond_with @post
  end
  
  def update
    @post = Post.find_by_id(params[:id])
    if @post.update_attributes(:title => params[:post][:title], :content => params[:post][:content])
      @post.tag_with_list(params[:post][:tag_list], current_user)
      respond_with @post
    else
      if @post.valid?
        flash[:error] = t(:post_failed_message)
      else
        flash[:error] = @post.errors.full_messages
      end
      @post = nil
      respond_with @post
    end
  end
  
  def destroy
    @post_id = @post.id
    @post.destroy
    respond_with @post_id
  end
  
  private
    def authorized_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path if @post.nil?
    end
end
