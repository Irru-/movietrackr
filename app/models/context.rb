class Context < ActiveRecord::Base
	belongs_to 	:user
	has_many						:ip_addresses
	accepts_nested_attributes_for 	:ip_addresses, allow_destroy: true, :reject_if => :all_blank

	has_many						:locations
	accepts_nested_attributes_for 	:locations, allow_destroy: true, :reject_if => :all_blank

	def get_locations_with_comma
		result = ""
		locations.each do |loc|
			result = result + loc.location + ", "
		end
		result[0..-3]
	end

	def get_ip_with_comma
		result = ""
		ip_addresses.each do |ip|
			result = result + ip.ip_address + ", "
		end
		result[0..-3]
	end	
end
