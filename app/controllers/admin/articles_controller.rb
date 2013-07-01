class Admin::ArticlesController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		@characters = Description.order_by("id DESC").paginate(:per_page=>per_page,:page => params[:page])
	end

	def new
		@article = Description.new
	end

	def edit
		@article = Description.find(params[:id].to_i)
	end

	def create
		@article = Description.new(params[:article])
		@article.save
		redirect_to admin_articles_path
	end
	def update
		id = params[:article].delete(:id)
		@article = Description.find(id.to_i)
		@article.update_attributes params[:article]
		redirect_to admin_articles_path
	end
end