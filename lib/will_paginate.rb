module WillPaginate
	class Collection
		def to_api_hash
			self.map{|i| i.to_api_hash} 
		end
	end
end