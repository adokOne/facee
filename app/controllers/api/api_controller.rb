class Api::ApiController < ApplicationController
  
  before_filter :create_result
  before_filter :authorize

  rescue_from Api::Exception , NoMethodError , :with => :send_error
  rescue_from ActionView::MissingTemplate,     :with => :send_response
  
  protected

  def authorize
      ::AppUser.login(params[:fb_id])
      $current_user.update_activity
  end

  def create_result
    @result  = {}
  	$request = request
  end

  def send_response
    render :json=>@result ,:status=>200 ,:content_type => 'application/json'
  end

  def send_error exc
    render :json=>{:error=>exc.message} ,:status=>500 ,:content_type => 'application/json'
  end

end