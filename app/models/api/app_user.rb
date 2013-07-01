class AppUser 
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :name, 	 	      type: String
  field :fb_id, 	      type: String
  field :gender, 	      type: String
  field :locale, 	      type: String
  field :active, 	      type: Integer, :default => 1
  field :last_activity, type: DateTime
  field :id, 			      type: Integer
  field :avatar, 	      type: String
  field :avatar_bg,     type: String
  field :key_id,        type: Moped::BSON::ObjectId
  auto_increment :id
  belongs_to :key
  has_many :coments,  :dependent => :destroy
  has_many :photos,   :dependent => :destroy
  has_many :albums,   :dependent => :destroy
  has_and_belongs_to_many :following, class_name: 'AppUser', inverse_of: :followers, autosave: true
  has_and_belongs_to_many :followers, class_name: 'AppUser', inverse_of: :following
  has_and_belongs_to_many :friend, class_name: 'AppUser', inverse_of: :friends, autosave: true
  has_and_belongs_to_many :friends, class_name: 'AppUser', inverse_of: :friend



  before_create :set_avatar
  before_create :set_key
  def update_activity
  	self.update_attribute :last_activity, Time.now.to_datetime
  end

  def set_avatar
  	uri = "#{Settings.facebook.url.graph}/#{self.fb_id}/picture".to_uri(:follow_redirects => false)
  	data = uri.get(Settings.app.photo_sizes.to_hash)
  	self[:avatar] = data.headers["location"]
  end

  def set_key
    self[:key_id] = Key.first.id
  end


  def to_api_hash
    {
      
      :created_at      => self.created_at,
      :fb_id           => self.fb_id,
      :gender          => self.gender,
      :last_activity   => self.last_activity,
      :followers_count => self.followers.count,
      :friends_count   => self.friends.count
    }.merge(to_small_hash)
  end

  def to_small_hash
    {
      :id     => self.id,
      :name   => self.name,
      :avatar => self.avatar
    }
  end

  def to_full_api_hash
    {
      :last_folowers     => self.followers.limit(Settings.app.folow_lim).map{|f| f.to_small_hash},
      :last_freiends     => self.friends.limit(Settings.app.friend_lim).map{|f| f.to_small_hash},
      :avatar_bg         => self.avatar_bg
    }.merge(to_api_hash)
  end


  def friend!(user)
    if self.id != user.id && !self.friend.include?(user)
      self.friend << user
    end
  end

  def unfriend!(user)
    self.friends.delete(user)
  end


  def follow!(user)
    if self.id != user.id && !self.following.include?(user)
      self.following << user
    elsif self.following.include?(user)
      self.following.delete(user)
    end
  end

  class << self 
	  def login fb_id
	  	@fb_id = fb_id
	  	raise Api::Exception.new(1) if @fb_id.nil?
	  	$current_user =  AppUser.find_or_create_by(:fb_id=>@fb_id) do |user|
	  		user_data.each_pair do |key,value|
	  			user[key] = value if AppUser.fields.keys.include? key
	  		end
	  	end
	  end

	  private 

	  def user_data 
	  	uri  = Settings.facebook.url.graph.to_uri
	  	data = uri[@fb_id].get.deserialise.with_indifferent_access
	  	if data.has_key? :error
	  		raise Api::Exception.new(2) 
	  	else
	  		return data
	  	end
	  end
  end

end
