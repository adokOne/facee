class Api::Logger
	class << self
		def log msg, text = nil, event = 1
			Log.create(:desc=>msg, :text=>text, :event=>event)
		end
	end
end