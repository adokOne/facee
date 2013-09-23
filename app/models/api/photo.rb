class Photo
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paperclip
  field          :app_user_id, :type => Moped::BSON::ObjectId
  field          :album_id   , :type => Moped::BSON::ObjectId
  field          :bd         , :type => Integer
  field          :description_payed, :type  => Boolean, :default => false
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

  #has_and_belongs_to_many :descriptions

 # before_save :check_album
 # before_save :set_user


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

 

  def to_json
    {
      :id             => self.id,
      :photo          => "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}",
      :like_count     => self.likes.count,
      :comments_count => self.coments.count,
      :created_at     => self.created_at,
      :description    => {:payed=>self.description_payed,:items=>descriptions.map(&:to_api_hash)}
    }
  end

  def to_strim
    to_json.merge({
      :user_id => self.app_user.id,
      :avatar  => self.app_user.avatar,
      :name    => self.app_user.name,
      :fb_id   => self.app_user.fb_id,
      :description    => {:payed=>self.description_payed,:items=>descriptions.first.nil? ? {} : descriptions.first.to_api_hash}
    })
  end

  def to_full_json
    {
      :last_likes     => self.likes.limit(Settings.app.like_lim).map(&:to_api_hash),
      :comments       => self.coments.limit(Settings.app.com_lim).map(&:to_api_hash),
    }.merge(to_json)
  end

  def descriptions
    data = Rails.cache.read("periods")
    idx = 0
    b_day   = Time.at(self.bd).to_date
    year  = Time.at(self.bd).year
    data.each_with_index do |item,k|
      from  = item.first.change(:year=>year)
      to    = item.last.change(:year=>year)
      idx = k if b_day >= from && b_day < to
    end
    Description.where(item_period:(idx - 1)).all
  end

  private

  def check_album
    Album.find($request.params[:album_id])
  rescue Mongoid::Errors::InvalidFind , Mongoid::Errors::DocumentNotFound 
    album = $current_user.albums.any? ? $current_user.albums.first :  Album.create(:name => "first")
    self.album = album
  end

  def set_user
    self.app_user = $current_user
  end

end
