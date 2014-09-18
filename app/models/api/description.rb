class Description

  include Mongoid::Document
  #store_in database: "facee_production"

  field :body_ru,   type: String , :default => ""
  field :body_ua,   type: String , :default => ""
  field :body_en,   type: String , :default => ""
  field :item_type, type: Integer, :default =>  1  
  field :item_period, type: Integer
  field :m_from, type: Integer
  field :m_to, type: Integer
  field :d_from, type: Integer
  field :d_to, type: Integer
  auto_increment :id, :type => Moped::BSON::ObjectId
  has_and_belongs_to_many :photos

  def body
  	self["body_#{I18n.locale}"]
  end

  def to_api_hash
    {:item_type=>self.item_type,:body=>self.body,:id=>self.id}
  end


  def self.generated_dates
    Description.periods.map{|per| per.map{|i|  DateTime.new(Time.now.year,i[:m],i[:d]).strftime("%d %b")}.join(" do ")}
  end

  def self.import
    i = 0
    Hash.from_xml(File.read("#{Rails.root}/desc.xml").gsub("\n",""))["root"]["item"].in_groups_of(8).each do |item|
      item.each do |g|
        d = {
          item_period:i,
          item_type: g["type"].gsub("t_","").to_i,
          body_en: g["text"].strip,
          body_ru: g["text"].strip,
          body_ua: g["text"].strip
        }
        p d
        Description.create(d)
      end
      i+=1
    end
    
  end



  def self.periods
    [ 
      [
        {
          m:3,d:21
        },
        {
          m:3,d:26
        },
      ],
      [
        {
          m:3,d:27
        },
        {
          m:4,d:1
        },
      ],
      [
        {
          m:4,d:2
        },
        {
          m:4,d:7
        },
      ],
      [
        {
          m:4,d:8
        },
        {
          m:4,d:13
        },
      ],
      [
        {
          m:4,d:14
        },
        {
          m:4,d:20
        },
      ],

      # OVEN END


      [
        {
          m:4,d:21
        },
        {
          m:4,d:26
        },
      ],
      [
        {
          m:4,d:27
        },
        {
          m:5,d:2
        },
      ],
      [
        {
          m:5,d:3
        },
        {
          m:5,d:8
        },
      ],
      [
        {
          m:5,d:9
        },
        {
          m:5,d:14
        },
      ], 
      [
        {
          m:5,d:15
        },
        {
          m:5,d:20
        },
      ], 
      #TELEC END 

      [
        {
          m:5,d:21
        },
        {
          m:5,d:26
        },
      ],
      [
        {
          m:5,d:27
        },
        {
          m:6,d:1
        },
      ],
      [
        {
          m:6,d:2
        },
        {
          m:6,d:7
        },
      ],
      [
        {
          m:6,d:8
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
      ],

      # BLIZNECU END
      [
        {
          m:6,d:22
        },
        {
          m:6,d:27
        },
      ],
      [
        {
          m:6,d:28
        },
        {
          m:7,d:3
        },
      ],
      [
        {
          m:7,d:4
        },
        {
          m:7,d:9
        },
      ],
      [
        {
          m:7,d:10
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
          m:7,d:22
        },
      ],


      #RACK GAI
      [
        {
          m:7,d:23
        },
        {
          m:7,d:28
        },
      ],
      [
        {
          m:8,d:29
        },
        {
          m:8,d:3
        },
      ],
      [
        {
          m:8,d:4
        },
        {
          m:8,d:9
        },
      ],
      [
        {
          m:8,d:10
        },
        {
          m:8,d:15
        },
      ],
      [
        {
          m:8,d:16
        },
        {
          m:8,d:23
        },
      ],

       # RAK END
      [
        {
          m:8,d:24
        },
        {
          m:8,d:29
        },
      ],
      [
        {
          m:9,d:30
        },
        {
          m:9,d:5
        },
      ],
      [
        {
          m:9,d:6
        },
        {
          m:9,d:11
        },
      ],
      [
        {
          m:9,d:12
        },
        {
          m:9,d:17
        },
      ],
      [
        {
          m:9,d:18
        },
        {
          m:9,d:23
        },
      ],

       # END DEVA
      [
        {
          m:9,d:24
        },
        {
          m:9,d:29
        },
      ],
      [
        {
          m:9,d:30
        },
        {
          m:10,d:6
        },
      ],
      [
        {
          m:10,d:7
        },
        {
          m:10,d:12
        },
      ],
      [
        {
          m:10,d:13
        },
        {
          m:10,d:18
        },
      ],
      [
        {
          m:10,d:19
        },
        {
          m:10,d:23
        },
      ],
      # END VESU
      [
        {
          m:10,d:24
        },
        {
          m:10,d:29
        },
      ],
      [
        {
          m:11,d:30
        },
        {
          m:11,d:4
        },
      ],
      [
        {
          m:11,d:5
        },
        {
          m:11,d:10
        },
      ],
      [
        {
          m:11,d:11
        },
        {
          m:11,d:16
        },
      ],
      [
        {
          m:11,d:17
        },
        {
          m:11,d:22
        },
      ],


       # END SKORPION
      [
        {
          m:11,d:23
        },
        {
          m:11,d:28
        },
      ],
      [
        {
          m:11,d:29
        },
        {
          m:12,d:4
        },
      ],
      [
        {
          m:12,d:5
        },
        {
          m:12,d:10
        },
      ],
      [
        {
          m:12,d:11
        },
        {
          m:12,d:16
        },
      ], 
      [
        {
          m:12,d:17
        },
        {
          m:12,d:21
        },
      ], 


      # END STRELEC
      [
        {
          m:12,d:22
        },
        {
          m:12,d:27
        },
      ],
      [
        {
          m:12,d:28
        },
        {
          m:1,d:2
        },
      ],
      [
        {
          m:1,d:3
        },
        {
          m:1,d:7
        },
      ],
      [
        {
          m:1,d:8
        },
        {
          m:1,d:13
        },
      ],
      [
        {
          m:1,d:14
        },
        {
          m:1,d:20
        },
      ],

       # END KOZEROG
      [
        {
          m:1,d:21
        },
        {
          m:1,d:26
        },
      ],
      [
        {
          m:1,d:27
        },
        {
          m:2,d:1
        },
      ],
      [
        {
          m:2,d:2
        },
        {
          m:2,d:7
        },
      ],
      [
        {
          m:2,d:8
        },
        {
          m:2,d:13
        },
      ],
      [
        {
          m:2,d:14
        },
        {
          m:2,d:20
        },
      ],

       # END VODOLEY
      [
        {
          m:2,d:21
        },
        {
          m:2,d:25
        },
      ],
      [
        {
          m:2,d:26
        },
        {
          m:3,d:3
        },
      ],
      [
        {
          m:3,d:4
        },
        {
          m:3,d:9
        },
      ],
      [
        {
          m:3,d:10
        },
        {
          m:3,d:15
        },
      ],
      [
        {
          m:3,d:16
        },
        {
          m:3,d:20
        },
      ],
    ]
  end





end
