class Tools
	class << self
		def process_picture photo,id,config
			 File.open("#{Rails.root}/public#{config.upload_dir}#{id}_pic.jpg", "wb") { |f| f.write(photo.read) }
			 return "#{config.upload_dir}#{id}_pic.jpg"
		end
	end
end