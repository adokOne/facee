class Coment

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :app_user_id ,  type: Moped::BSON::ObjectId
  field :photo_id,      type: Moped::BSON::ObjectId
  field :text,		    type: String
  auto_increment :id, :type => Moped::BSON::ObjectId

  belongs_to :app_user
  belongs_to :photo

  before_save :set_user

  private

  def to_api_hash
    {:user_id=>self.app_user.id,:name=>self.app_user.name,:comment=>self.text}
  end


  def set_user
    self.app_user = $current_user
  end

end
