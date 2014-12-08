class MainController < ApplicationController
  
  def index
  	@feedback = Feedback.new
  end

  def item 
  	@photo = Photo.where(id:params[:id].to_i).first
  	raise "Photo not found" if @photo.nil?
  end
  def index_old
  	render :layout =>"application_old"
  end
end
