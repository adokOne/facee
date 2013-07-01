class Description

  include Mongoid::Document

  field :body_ru,   type: String , :default => ""
  field :body_ua,   type: String , :default => ""
  field :body_en,   type: String , :default => ""
  field :name_ru,   type: String , :default => ""
  field :name_ua,   type: String , :default => ""
  field :name_en,   type: String , :default => ""
  field :item_type, type: Integer, :default =>  1  
  auto_increment :id, :type => Moped::BSON::ObjectId
  has_and_belongs_to_many :photos

  def body
  	self["body_#{I18n.locale}"]
  end
  def name
  	self["name_#{I18n.locale}"]
  end

  def to_api_hash
    {:item_type=>self.item_type,:body=>self.body,:id=>self.id}
  end

end
