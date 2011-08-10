class PagesController < ApplicationController
  def home
    @title = t(:home)
    if signed_in?
      @post = Post.new
      @stream = current_user.stream.paginate(:page => params[:page])
    end
  end
  
  def about
    @title = t(:about)
  end
  
  def contact
    @title = t(:contact)
  end
  
  def help
    @title = t(:help)
  end
  
  def news
    @title = t(:news)
  end
end
