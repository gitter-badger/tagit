class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :redirect_signed_in_user, :only => [:new, :create]  
  before_filter :authenticate_admin, :only => :destroy
  
	def index
    @title = t(:user).pluralize
    query = "%#{params[:search]}%"
    @users = User.where("name LIKE ? OR username LIKE ?", query, query).paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @posts = @user.posts.paginate(:page => params[:page])
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
      flash[:success] = t(:welcome_message)
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
      flash[:success] = t(:profile_updated_message)
      redirect_to @user
    else
      @title = t(:edit_profile)
      render "users/edit"
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if user != current_user
      user.destroy
      flash[:success] = t(:user_deleted_message)
    else
      flash[:error] = t(:user_not_deleted_message)
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
