class Feedback < ActiveRecord::Base
  attr_accessible :email,:subject,:message
end
