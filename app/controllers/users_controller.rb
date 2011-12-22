class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :redirect_signed_in_user, :only => [:new, :create]  
  before_filter :authenticate_admin, :only => :destroy
  
  respond_to :html, :js
  
	def index
    @title = t(:user).pluralize
    query = "%#{params[:search]}%"
    @users = User.where("name LIKE ? OR username LIKE ?", query, query).paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    tagged_or_posted_post_ids = (@user.posts.map{ |post| post.id } + @user.post_tags.map{ |post_tag| post_tag.post_id }).uniq
    @posts = Post.where(:id => tagged_or_posted_post_ids).paginate(:page => params[:page])
    if request.xhr?
      render :partial => "posts/post", :collection => @posts
    end
  end
  
	def new
		@title = t(:sign_up)
    @user = User.new
	end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:notice] = t(:welcome_message)
      redirect_to @user
    else
      @title = t(:sign_up)
      @user.password = ""
      @user.password_confirmation = ""
      render "users/new"
    end
  end
  
  def edit
    @title = t(:edit_profile)
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:profile_updated_message)
      redirect_to @user
    else
      @title = t(:edit_profile)
      render "users/edit"
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      flash[:error] = t(:user_not_deleted_message)
    else
      user.destroy
      flash[:notice] = t(:user_deleted_message)
    end
    redirect_to users_path
  end
  
  def following
    @title = t(:following)
    show_follow(:following)
  end

  def followers
    @title = t(:follower).pluralize
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render "users/show_relationships"
  end
  
  def settings
    current_user.settings.collapse_posts = params[:collapse_posts] unless params[:collapse_posts].nil?
  end
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def authenticate_admin
      if current_user.nil?
        redirect_to(signin_path)
      else
        redirect_to(root_path) unless current_user.admin?
      end
    end
    
    def redirect_signed_in_user
      redirect_to(root_path) if signed_in?
    end
end
