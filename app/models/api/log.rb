class Log

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :desc,    type: String
  field :text,    type: String
  field :event,   type: Integer, :default =>1

end
