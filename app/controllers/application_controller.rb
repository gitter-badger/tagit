class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  after_filter :flash_to_headers
  
  def flash_to_headers
    return unless request.xhr?
    response.headers["X-Error-Message"] = flash[:error] unless flash[:error].blank?
    response.headers["X-Warning-Message"] = flash[:warning] unless flash[:warning].blank?
    response.headers["X-Notice-Message"] = flash[:notice] unless flash[:notice].blank?
    
    flash.discard  # we don't want the flash to appear when we reload the page
  end
end
