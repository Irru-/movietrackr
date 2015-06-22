class Context < ActiveRecord::Base

	belongs_to 	:user
	has_many						:ip_addresses
	accepts_nested_attributes_for 	:ip_addresses, allow_destroy: true, :reject_if => :all_blank

	has_many						:locations
	accepts_nested_attributes_for 	:locations, allow_destroy: true, :reject_if => :all_blank

end
