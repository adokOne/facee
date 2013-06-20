class Photo
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paperclip
  field          :app_user_id, :type => Moped::BSON::ObjectId
  field          :album_id   , :type => Moped::BSON::ObjectId
  auto_increment :id 

  has_mongoid_attached_file :picture, :path => "public/system/photos/:app_user_id/:id/:style.:extension",    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
  }

  

  Paperclip.interpolates :app_user_id do |attachment, style|
    "#{attachment.instance.app_user_id}"
  end

  belongs_to     :app_user
  belongs_to     :album
  has_many       :coments , :dependent => :destroy
  has_many       :likes,    :dependent => :destroy , :autosave => true

  has_and_belongs_to_many :characters

  before_save :check_album
  before_save :set_user


  def like!
    like = Like.where(:app_user_id=>$current_user.id).first
    if !like.nil? && self.likes.include?(like)
      self.likes.delete(like)
    else
      like = Like.new
      like.photo = self
      like.save
    end
  end

 

  def to_json
    {
      :id             => self.id,
      :photo          => "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}",
      :like_count     => self.likes.count,
      :comments_count => self.coments.count,
      :created_at     => self.created_at
    }
  end

  def to_strim
    {
      :user_id => self.app_user.id,
      :name    => self.app_user.name,
      :fb_id   => self.app_user.fb_id,
    }.merge(to_json)
  end

  def to_full_json
    {
      :last_likes     => self.likes.limit(Settings.app.like_lim).map{|comm| comm.to_api_hash},
      :comments       => self.coments.limit(Settings.app.com_lim).map{|comm| comm.to_api_hash},
    }.merge(to_json)
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
