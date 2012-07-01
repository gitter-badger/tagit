require 'will_paginate/array' # TODO: Remove

class PagesController < ApplicationController
  def home
    @title = t(:home)
    
    if signed_in?
      @post = Post.new
      unless request.xhr?
        @stream = current_user.stream.paginate(:page => params[:page])
        #@stream = current_user.twitter_stream.paginate(:page => params[:page])
        session[:latest_post_id] = @stream.first.id unless @stream.empty?
      else
        @stream = current_user.stream.where('"posts".id <= ?', session[:latest_post_id]).paginate(:page => params[:page])
        render :partial => "posts/post", :collection => @stream
      end
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
