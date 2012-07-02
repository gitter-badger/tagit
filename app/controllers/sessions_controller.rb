class SessionsController < ApplicationController
  def new
    @title = t(:sign_in)
  end

  def create
    if params[:session].present? && params[:session][:email].present? && params[:session][:password].present? # standard sign in
      user = User.authenticate(params[:session][:email], params[:session][:password])
    elsif params[:provider] == "twitter" && request.env["omniauth.auth"]["credentials"]["token"].present? && request.env["omniauth.auth"]["credentials"]["secret"].present? # Twitter sign in
      user = User.authenticate_with_twitter(request.env["omniauth.auth"]["credentials"]["token"], request.env["omniauth.auth"]["credentials"]["secret"])
    end
    if user.nil?
      flash.now[:error] = t(:invalid_login_message)
      @title = t(:sign_in)
      render 'sessions/new'
    else
      sign_in user
      redirect_back_or root_path
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
