class Photo
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paperclip
  field          :app_user_id, :type => Moped::BSON::ObjectId
  field          :album_id   , :type => Moped::BSON::ObjectId
  field          :bd         , :type => Integer,  :default => Time.now.to_i
  field          :description_payed, :type  => Boolean, :default => false
  field          :gender, :type => Integer,:default => 1
  field          :friend_type, :type => Integer,:default => 1
  field          :friend_fb_id, :type => String, :default => ""
  field          :friend_id, :type => Integer
  
  auto_increment :id 

  has_mongoid_attached_file :picture, :path => "public/system/photos/:app_user_id/:id/:style.:extension",    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['560x560',    :jpg],
      :large    => ['500x500>',   :jpg]
  }
  default_scope order_by([:created_at, :desc])
  

  Paperclip.interpolates :app_user_id do |attachment, style|
    "#{attachment.instance.app_user_id}"
  end

  belongs_to     :app_user
  belongs_to     :album
  has_many       :coments , :dependent => :destroy
  has_many       :likes,    :dependent => :destroy , :autosave => true


  before_save :set_user
  before_save :set_friend


  def like!
    like = Like.where(:app_user_id=>$current_user.id,:photo_id=>self.id).first
    unless like.nil? 
      self.likes.delete(like) 
      0
    else
      Like.create(:photo_id=>self.id) 
      1
    end
  end

  def name
    self.friend_type == 1 ? self.app_user.name : (self.friend_type == 2 ? self.friend.name : self.friend_fb_id)
  end

 

  def to_json
    descs = self.description_payed ? descriptions.all.map(&:to_api_hash) : descriptions.where(item_type:1).all.map(&:to_api_hash)
    {
      :id             => self.id,
      :photo          => "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}",
      :like_count     => self.likes.count,
      :comments_count => self.coments.count,
      :created_at     => self.created_at,
      :description    => {:payed=>self.description_payed,:items=>descs},
      :name           => self.app_user.name,
      :persone_name   => name,
    }
  end

  def to_strim
    to_json.merge({
      :user_id => self.app_user.id,
      :avatar  => self.app_user.avatar,
      :fb_id   => self.app_user.fb_id,
      :like    => !Like.where(:app_user_id=>$current_user.id,:photo_id=>self.id).first.nil?,
      :description    => {:payed=>self.description_payed,:items=>descriptions.where(item_type:1).first.nil? ? {} : descriptions.where(item_type:1).first.to_api_hash}
    })
  end

  def to_full_json
    {
      :last_likes     => self.likes.limit(Settings.app.like_lim).map(&:to_api_hash),
      :comments       => self.coments.limit(Settings.app.com_lim).map(&:to_api_hash),
    }.merge(to_json)
  end

  def descriptions
    data = Description.generated_dates
    idx = 0
    b_day   = Time.at(self.b_day).to_date
    year    = Time.at(self.b_day).year
    data.each_with_index do |item,k|
      from  = item.first.change(:year=>year)
      to    = item.last.change(:year=>year)
      idx = k if b_day >= from && b_day < to
    end
    idx = idx == 0 ? 0 : idx - 1
    Description.where(item_period:idx)
  end

  def b_day
    self.friend_type == 2 ? self.friend.b_day.nil? ? 0 : self.friend.b_day : self.bd
  end

  def is_own
    self.friend_type == 1 ? true : nil
  end

  def friend
    AppUser.find(self.friend_id)
  end

  private

  def check_album
    Album.find($request.params[:album_id])
  rescue Mongoid::Errors::InvalidFind , Mongoid::Errors::DocumentNotFound 
    album = $current_user.albums.any? ? $current_user.albums.first :  Album.create(:name => "first")
    self.album = album
  end

  def set_user
    self.app_user = $current_user unless $current_user.nil?
  end

  def set_friend
    if self.friend_type == 2 && self.friend_fb_id.size > 0
      u = AppUser.find_or_create_by(:fb_id=>self.friend_fb_id) do |user|
        AppUser.user_data(self.friend_fb_id).each_pair do |key,value|
          user[key] = value if AppUser.fields.keys.include? key
        end
      end
      self.friend_id = u.id
    elsif self.friend_type == 1 && !$current_user.nil? && $current_user.own_photos_count == 1 
      $current_user.update_attribute(:b_day,self.bd)
    end
  end

end
