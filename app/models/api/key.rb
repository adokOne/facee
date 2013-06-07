class Key

  include Mongoid::Document

  field :secret,		    :type  => String
  auto_increment :id,   :type => Moped::BSON::ObjectId

  has_many :app_user

end
