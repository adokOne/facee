class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_and_belongs_to_many :roles

  def modules
  	modules = []
  	self.roles.each do |role|
  		modules << role.admin_modules 
  	end
  	modules.flatten
  end

  def is_admin?
    self.roles.include?(Role.find_by_role_type(:admin))
  end

  def has_access?
  	self.active > 0
  end

  
end
