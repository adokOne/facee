class Character

  include Mongoid::Document

  field :desc_ru,   type: String
  field :desc_ua,   type: String
  field :desc_en,   type: String
  field :item_id,   type: Integer
  
  has_and_belongs_to_many :photos

  def desc
  	self["desc_#{I18n.locale}"]
  end

end
