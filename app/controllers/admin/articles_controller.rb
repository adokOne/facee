class Admin::ArticlesController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		@characters = Character.order_by("id DESC").paginate(:per_page=>per_page,:page => params[:page])
	end

	def new
		@character = Character.new
	end
end