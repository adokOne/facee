class AdminController < ApplicationController
	protect_from_forgery
	layout "admin"
	
	def index
		render :layout =>"admin_login" unless logged_in? && current_user.is_admin? && current_user.has_access?
	end

end
