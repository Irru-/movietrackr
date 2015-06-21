module FormHelper

	def setup_context(context)
		1.times {context.locations.build }
		1.times {context.ip_addresses.build }
		context
	end

end