class Admin::ArticlesController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		type = params[:type] || 1
		@characters = Description.where(:item_type=>type).order_by("id DESC").paginate(:per_page=>per_page,:page => params[:page])
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
		@periods = []
		 Description.generated_dates.size.times do |g| 
			first = [Description.generated_dates[g].first.day, I18n.t("date.month_names")[Description.generated_dates[g].first.month] ].join(" ")
			last  = [Description.generated_dates[g].last.day, I18n.t("date.month_names")[Description.generated_dates[g].last.month] ].join(" ")
			@periods << [[ first, last ].join(" do ") , g]
		end
	end
end