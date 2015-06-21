class ContextController < ApplicationController
	def index
		@users = User.all
	end

	def new
		
	end

	def edit
		p 			= params
		context_id	= p[:id]

		@context 	= Context.find(context_id)
		@user 		= User.find(@context.user_id)
		@locations	= @context.get_locations_with_comma
		@ips		= @context.get_ip_with_comma		
	end

	def update
		@context 	= Context.find(params[:id])
		Rails.logger.debug "params = #{params}"
		if @context.update_attributes(context_params)
			redirect_to context_index_path
		else

		end
	end

	private

		def context_params
			params.require(:context).permit(:user_id, :starting_time, :ending_time,
			locations_attributes: [:id, :location, :_destroy], ip_addresses_attributes: [:id, :ip_address, :_destroy])
		end
end
