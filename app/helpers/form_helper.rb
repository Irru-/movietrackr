module FormHelper

	def setup_context(context)
		2.times {context.locations.build }
		2.times {context.ip_addresses.build }
		context
	end

end