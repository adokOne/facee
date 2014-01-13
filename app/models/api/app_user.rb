class AppUser 
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :last_activity, type: DateTime
  field :id, 			      type: Integer
  field :app_id,        type: String
  field :key_id,        type: Moped::BSON::ObjectId
  auto_increment :id
  belongs_to :key
  has_many :photos,   :dependent => :destroy

  before_create :set_key

  def update_activity
  	self.update_attribute :last_activity, Time.now.to_datetime
  end

  def set_key
    self[:key_id] = Key.first.id
  end

  class << self 
	  def login fb_id
	  	@fb_id = fb_id
	  	raise Api::Exception.new(1) if @fb_id.nil?
	  	$current_user =  AppUser.find_or_create_by(:app_id=>@fb_id)
	  end
  end

end
