class Api::ApiController < ApplicationController

  before_filter :chek_access
  before_filter :create_result
  before_filter :authorize

  rescue_from Api::Exception , NoMethodError , :with => :send_error
  rescue_from ActionView::MissingTemplate,     :with => :send_response
  
  def routing_error
    #raise Api::Exception.new(11)
  end

  protected
  
  def authorize
      ::AppUser.login(params[:app_id])
      $current_user.update_activity
  end

  def chek_access
    ::Key.find_by(secret:params[:key])
    rescue Mongoid::Errors::DocumentNotFound
      raise Api::Exception.new(10)
  end

  def create_result
    I18n.locale = params[:lang] if params[:lang].present? && %w(ru en).include?(params[:lang])
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
