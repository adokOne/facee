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
  auto_increment :id

  has_many :coments,  :dependent => :destroy
  has_many :photos,   :dependent => :destroy
  has_many :albums,   :dependent => :destroy
  has_and_belongs_to_many :following, class_name: 'AppUser', inverse_of: :followers, autosave: true
  has_and_belongs_to_many :followers, class_name: 'AppUser', inverse_of: :following
  has_and_belongs_to_many :friend, class_name: 'AppUser', inverse_of: :friends, autosave: true
  has_and_belongs_to_many :friends, class_name: 'AppUser', inverse_of: :friend




  after_initialize :update_activity
  before_create :set_avatar

  def update_activity
  	self.update_attribute :last_activity, Time.now.to_datetime
  end

  def set_avatar
  	uri = "#{Settings.facebook.url.graph}/#{self.fb_id}/picture".to_uri(:follow_redirects => false)
  	data = uri.get(Settings.app.photo_sizes.to_hash)
  	self[:avatar] = data.headers["location"]
  end

  def to_full_json
    self.to_json
  end


  def friend!(user)
    if self.id != user.id && !self.friend.include?(user)
      self.following << user
    end
  end

  def unfriend!(user)
    self.friends.delete(user)
  end


  def follow!(user)
    if self.id != user.id && !self.following.include?(user)
      self.following << user
    end
  end

  def unfollow!(user)
    self.following.delete(user)
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
