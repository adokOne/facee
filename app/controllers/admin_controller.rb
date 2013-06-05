class AdminController < ApplicationController
	protect_from_forgery
	layout "admin"
	
	def index
		render :layout =>"admin_login" unless logged_in? && current_user.is_admin? && current_user.has_access?
	end

	def login_admin
		login(params[:user][:email],params[:user][:password],true)
		json = logged_in? ? {:success=>true} : {:succes=>false,:error=>t("user.errors.default_login_error")}
		render :json => json
	end
	def exit
		logout
		redirect_to :root
	end
end
