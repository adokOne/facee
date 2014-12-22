class MainController < ApplicationController
  def initialize
    @meta = {}
    @meta["og:site_name"] = "Phiz"
    
    super
  end
  def index
  	@feedback = Feedback.new
  end

  def item 
    $request = request
  	@photo = Photo.where(id:params[:id].to_i).first
  	raise "Photo not found" if @photo.nil?
    @meta["og:site_name"] = "Phiz"
    @meta["og:description"] = @photo.descriptions.where(item_type:1).first.body
    @meta["og:image"] = @photo.photo_url
    @meta["og:url"] = "#{request.protocol}#{request.host}/item/#{@photo.id}"
  end
  def index_old
  	render :layout =>"application_old"
  end
end
