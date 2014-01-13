class Photo
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paperclip
  field          :app_user_id, :type => Moped::BSON::ObjectId
  field          :bd         , :type => Integer,  :default => Time.now.to_i


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

  before_save :set_user

  def to_json
    {
      :id             => self.id,
      :photo          => "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}",
      :created_at     => self.created_at,
      :descriptions   => descriptions.all.map(&:to_api_hash),
    }
  end

  def to_strim
    {
      :id             => self.id,
      :photo          => "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}",
      :created_at     => self.created_at,
      :description    => descriptions.where(item_type:1).first.nil? ? {} : descriptions.where(item_type:1).first.to_api_hash
    }
  end
 
  def descriptions
    data = Description.with(database: "facee_production").generated_dates
    idx = 0
    b_day   = Time.at(self.bd).to_date
    year    = Time.at(self.bd).year
    data.each_with_index do |item,k|
      from  = item.first.change(:year=>year)
      to    = item.last.change(:year=>year)
      idx = k if b_day >= from && b_day < to
    end
    idx = idx == 0 ? 0 : idx - 1
    Description.where(item_period:idx)
  end

  def is_own
    self.friend_type == 1 ? true : nil
  end

  private

  def set_user
    self.app_user = $current_user unless $current_user.nil?
  end

end
