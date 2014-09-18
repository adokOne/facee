class Admin::ArticlesController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		type = params[:type] || 1
		@characters = Description.where(:item_type=>type).order_by("item_period ASC").paginate(:per_page=>per_page,:page => params[:page])
	end

	def new
		get_periods
		@article = Description.new
	end

	def edit
		get_periods
		@article = Description.find(params[:id].to_i)
	end

	def create
		params[:article][:item_type].gsub!("t_",'')
		@article = Description.new(params[:article])
		@article.save
		redirect_to admin_articles_path
	end
	def update
		params[:article][:item_type].gsub!("t_",'')
		id = params[:article].delete(:id)
		@article = Description.find(id.to_i)
		@article.update_attributes params[:article]
		redirect_to admin_articles_path
	end

	private

	def get_periods
		@periods = Description.generated_dates
	end
end