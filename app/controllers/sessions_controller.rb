class SessionsController < ApplicationController
  def new
    @title = t(:sign_in)
  end
  
  def create
    if request.env["omniauth.auth"].present?
      token = request.env["omniauth.auth"]["credentials"]["token"]
      secret = request.env["omniauth.auth"]["credentials"]["secret"]
    end
    
    if params[:session].present? && params[:session][:email].present? && params[:session][:password].present? # standard sign in
      user = User.authenticate(params[:session][:email], params[:session][:password])
    elsif token.present? && secret.present? # alternate sign in / connect
      session[:oauth_provider] = params[:provider]
      case params[:provider]
      when "twitter"
        if signed_in? # connect
          session[:twitter_token] = token
          session[:twitter_secret] = secret
          flash[:notice] = t(:connect_alternate_account_success_message) % { :provider => params[:provider].capitalize }
          redirect_to edit_user_path(current_user) and return
        else # sign in
          user = User.authenticate_with_twitter(token, secret)
        end
      end
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
