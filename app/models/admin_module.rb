class AdminModule < ActiveRecord::Base
  attr_accessible :action, :name, :parent_id ,:ico_cls
  has_and_belongs_to_many :roles
end
