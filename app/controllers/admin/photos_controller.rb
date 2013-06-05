class Admin::PhotosController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		@photos = Photo.order_by("id DESC").paginate(:per_page=>per_page,:page => params[:page])
	end
end