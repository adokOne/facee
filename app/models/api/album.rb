class Album 
  include Mongoid::Document
 

  field :app_user_id , type: Moped::BSON::ObjectId
  field :name,		   type: String
  auto_increment :id 

  belongs_to :app_user
  has_many   :photos

  before_save :set_user


  def set_user
    self.app_user = $current_user
  end


end
