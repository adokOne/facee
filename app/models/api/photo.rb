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

  def photo_url
    "#{$request.protocol}#{$request.host}#{Settings.app.image_dir}#{self.app_user.id}/#{self.id}/#{Settings.app.image_name}#{Settings.app.image_ext}"
  end
 
  def descriptions
    date = Time.at(self.bd)
    day  = date.day
    mth  = date.month

    idx = periods.each_with_index do |period,key|
      from = period.first
      to   = period.last
      from = DateTime.new(date.year,from[:m],from[:d]).to_time 
      to   = DateTime.new(date.year,to[:m],to[:d]).to_time
      if to < from 
        date =  date.change(:year=>to.year + 1)
        to   =  to.change(:year=>to.year + 1)
      end
      break key if (from.beginning_of_day..to.end_of_day).cover?(date)
    end
    Description.with(database: "facee_production").where(item_period:idx)
  end

  private

  def set_user
    self.app_user = $current_user unless $current_user.nil?
  end

  def periods
    [ 
      [
        {
          m:3,d:21
        },
        {
          m:3,d:27
        },
      ],
      [
        {
          m:3,d:28
        },
        {
          m:4,d:3
        },
      ],
      [
        {
          m:4,d:4
        },
        {
          m:4,d:11
        },
      ],
      [
        {
          m:4,d:12
        },
        {
          m:4,d:20
        },
      ],# OVEN END
      [
        {
          m:4,d:21
        },
        {
          m:4,d:27
        },
      ],
      [
        {
          m:4,d:28
        },
        {
          m:5,d:4
        },
      ],
      [
        {
          m:5,d:5
        },
        {
          m:5,d:12
        },
      ],
      [
        {
          m:5,d:13
        },
        {
          m:5,d:21
        },
      ], #TELEC END 
      [
        {
          m:5,d:22
        },
        {
          m:5,d:29
        },
      ],
      [
        {
          m:5,d:30
        },
        {
          m:6,d:5
        },
      ],
      [
        {
          m:6,d:6
        },
        {
          m:6,d:13
        },
      ],
      [
        {
          m:6,d:14
        },
        {
          m:6,d:21
        },
      ], # BLIZNECU END
      [
        {
          m:6,d:22
        },
        {
          m:6,d:29
        },
      ],
      [
        {
          m:6,d:30
        },
        {
          m:7,d:7
        },
      ],
      [
        {
          m:7,d:8
        },
        {
          m:7,d:15
        },
      ],
      [
        {
          m:7,d:16
        },
        {
          m:7,d:23
        },
      ], #RACK GAI
      [
        {
          m:7,d:24
        },
        {
          m:7,d:31
        },
      ],
      [
        {
          m:8,d:1
        },
        {
          m:8,d:7
        },
      ],
      [
        {
          m:8,d:8
        },
        {
          m:8,d:16
        },
      ],
      [
        {
          m:8,d:17
        },
        {
          m:8,d:23
        },
      ], # RAK END
      [
        {
          m:8,d:24
        },
        {
          m:8,d:30
        },
      ],
      [
        {
          m:9,d:1
        },
        {
          m:9,d:8
        },
      ],
      [
        {
          m:9,d:9
        },
        {
          m:9,d:16
        },
      ],
      [
        {
          m:9,d:17
        },
        {
          m:9,d:23
        },
      ], # END DEVA
      [
        {
          m:9,d:24
        },
        {
          m:9,d:30
        },
      ],
      [
        {
          m:10,d:1
        },
        {
          m:10,d:8
        },
      ],
      [
        {
          m:10,d:9
        },
        {
          m:10,d:16
        },
      ],
      [
        {
          m:10,d:17
        },
        {
          m:10,d:23
        },
      ], # END VESU
      [
        {
          m:10,d:24
        },
        {
          m:10,d:31
        },
      ],
      [
        {
          m:11,d:1
        },
        {
          m:11,d:8
        },
      ],
      [
        {
          m:11,d:8
        },
        {
          m:11,d:15
        },
      ],
      [
        {
          m:11,d:16
        },
        {
          m:11,d:22
        },
      ], # END SKORPION
      [
        {
          m:11,d:23
        },
        {
          m:11,d:29
        },
      ],
      [
        {
          m:11,d:30
        },
        {
          m:12,d:6
        },
      ],
      [
        {
          m:12,d:7
        },
        {
          m:12,d:15
        },
      ],
      [
        {
          m:12,d:16
        },
        {
          m:12,d:21
        },
      ], # END STRELEC
      [
        {
          m:12,d:22
        },
        {
          m:12,d:28
        },
      ],
      [
        {
          m:12,d:29
        },
        {
          m:1,d:5
        },
      ],
      [
        {
          m:1,d:6
        },
        {
          m:1,d:12
        },
      ],
      [
        {
          m:1,d:13
        },
        {
          m:1,d:20
        },
      ], # END KOZEROG
      [
        {
          m:1,d:21
        },
        {
          m:1,d:27
        },
      ],
      [
        {
          m:1,d:28
        },
        {
          m:2,d:4
        },
      ],
      [
        {
          m:2,d:5
        },
        {
          m:2,d:12
        },
      ],
      [
        {
          m:2,d:13
        },
        {
          m:2,d:19
        },
      ], # END VODOLEY
      [
        {
          m:2,d:20
        },
        {
          m:2,d:26
        },
      ],[
        {
          m:2,d:27
        },
        {
          m:3,d:6
        },
      ],      [
        {
          m:3,d:7
        },
        {
          m:3,d:13
        },
      ],      [
        {
          m:3,d:14
        },
        {
          m:3,d:20
        },
      ],

    ]
  end


end
