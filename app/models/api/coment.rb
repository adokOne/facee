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

  def to_api_hash
    {:user_id=>self.app_user.id,:name=>self.app_user.name,:comment=>self.text}
  end

  def to_full_api_hash
    {
      :id         => self.id,
      :created_at => self.created_at,
      :photo_id   => self.photo_id,
      :fb_id      => self.app_user.fb_id
    }.merge(to_api_hash)
  end

  private 
  def set_user
    self.app_user = $current_user
  end

end
