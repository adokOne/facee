class Admin::UsersController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@users = AppUser.order_by("#{sort} #{@dir}").paginate(:per_page=>per_page,:page => params[:page])
	end

	def new
		@user  = User.new
		@roles = Role.all.map{|role| [role.name,role.id]}
		@pass  = SecureRandom.hex(10)
	end

	def edit
		@user = AppUser.find(params[:id].to_i)
	end

	def update
		user = AppUser.find(params[:id].to_i)
		user.update_attributes(params[:app_user])
		redirect_to admin_users_path
	end

end
