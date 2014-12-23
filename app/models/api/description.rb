class Description

  include Mongoid::Document
  store_in database: "facee_production"
  with(database: "facee_production")
  field :body_ru,   type: String , :default => ""
  field :body_ua,   type: String , :default => ""
  field :body_en,   type: String , :default => ""
  field :item_type, type: Integer, :default =>  1  
  field :item_period, type: Integer
  auto_increment :id, :type => Moped::BSON::ObjectId
  has_and_belongs_to_many :photos

  def body
  	self["body_#{I18n.locale}"]
  end

  def to_api_hash
    {:item_type=>self.item_type,:body=>self.body,:id=>self.id}
  end


  def self.generated_dates
    unless periods = Rails.cache.read("periods")
      start_date = Date.new.at_beginning_of_year
      end_date   = Date.new.at_beginning_of_year.next_year
      periods = []
      para = []
      while start_date != end_date and start_date.year < end_date.year
        para << start_date == Date.new.at_beginning_of_year ? start_date :  start_date - 1.day
        if para.size == 2
          periods << para
          para = [para.last]
        end
        start_date += 7.day
      end
      Rails.cache.write("periods",periods,:expires_in=>5.month)
    end
    periods
  end

end
