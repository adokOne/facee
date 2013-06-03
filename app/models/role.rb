class Role < ActiveRecord::Base
  attr_accessible :name ,:role_type
  has_and_belongs_to_many :users 
  has_and_belongs_to_many :admin_modules
end
