class Photo
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paperclip
  field          :app_user_id, :type => Moped::BSON::ObjectId
  field          :bd         , :type => Integer,  :default => Time.now.to_i


  auto_increment :id 

  has_mongoid_attached_file :picture, :path => "public/system/photos/:app_user_id/:id/:style:extension"
  default_scope order_by([:created_at, :desc])
  

  Paperclip.interpolates :app_user_id do |attachment, style|
    "#{attachment.instance.app_user_id}"
  end
  Paperclip.interpolates :extension do |attachment, style|
    Settings.app.image_ext
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
    @ranges = {
      self.range_for(1,  1,  1,  20) => [0,1,2,3],
      self.range_for(1,  21, 2,  19) => [4,5,6,7],
      self.range_for(2,  20, 3,  20) => [8,9,10,11],
      self.range_for(3,  21, 4,  20) => [12,13,14,15],
      self.range_for(4,  21, 5,  21) => [16,17,18,19],
      self.range_for(5,  22, 6,  21) => [20,21,22,23],
      self.range_for(6,  22, 7,  22) => [24,25,26,27],
      self.range_for(7,  23, 8,  21) => [28,29,30,31],
      self.range_for(8,  22, 9,  23) => [32,33,34,35],
      self.range_for(9,  24, 10, 23) => [36,37,38,39],
      self.range_for(10, 24, 11, 22) => [40,41,42,43],
      self.range_for(11, 23, 12, 22) => [44,45,46,47],
      self.range_for(12, 23, 12, 31) => [48,49,50,51],
    }
    @keys = []
    @ranges.each_pair do |k,v|
      @keys = v if k.include_with_range?(Time.at(self.bd).change(:year=>2012).to_datetime)
    end
    idx = @keys.any? ? @keys.sample : 0
    Description.where(item_period:idx)
  end
  def date_for(month, day)
    DateTime.new(2012, month, day)
  end
  
  def range_for(month_start, day_start, month_end, day_end)
    start, ending = date_for(month_start, day_start), date_for(month_end, day_end)
    Range.new(start.beginning_of_day, ending.end_of_day)
  end
  private

  def set_user
    self.app_user = $current_user unless $current_user.nil?
  end


end
