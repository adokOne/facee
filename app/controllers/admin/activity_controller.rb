class Admin::ActivityController < AdminController
	before_filter :require_login
	def index

	end
end