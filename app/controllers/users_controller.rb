class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :redirect_signed_in_user, :only => [:new, :create]  
  before_filter :authenticate_admin, :only => :destroy
  
	def index
    @title = t(:user).pluralize
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(:page => params[:page])
    @title = @user.name
  end
  
	def new
    @user = User.new
		@title = t(:sign_up)
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
      render 'new'
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
      render 'edit'
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
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_relationships'
  end

  def followers
    @title = t(:follower).pluralize
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_relationships', :users => @users, :user => @user
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
