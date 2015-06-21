class ContextController < ApplicationController
	def index
		@users = User.all
		@suggested_ips 			= Stepup.group(:ip, :user_id).count.select{|k,v| v > 4 && !k[0].nil?}
		@suggested_locations 	= Stepup.group(:location, :user_id).count.select{|k,v| v > 4 && !k[0].nil?}
	end

	def new
		
	end

	def edit
		p 			= params
		context_id	= p[:id]

		@context 	= Context.find(context_id)
		@user 		= User.find(@context.user_id)
		@loc_size	= Context.find(context_id).locations.size
		@ip_size	= Context.find(context_id).ip_addresses.size

	end

	def update
		Rails.logger.debug "params = #{params}"

		if params[:suggested]
			if (params[:suggested][/\d/].nil?)
				#remove location
				Stepup.where(:location => params[:suggested]).where(:user_id => params[:context][:user_id]).delete_all
			elsif (params[:suggested].include? ":")
				#remove time
			else
				#remove ip
				Stepup.where(:ip => params[:suggested]).where(:user_id => params[:context][:user_id]).delete_all
			end
		end



		@context 	= Context.find(params[:id])
		if @context.update_attributes(context_params)
			redirect_to context_index_path
		else

		end
	end

	def suggested

	end

	private

		def context_params
			params.require(:context).permit(:user_id, :starting_time, :ending_time,
			locations_attributes: [:id, :location, :_destroy], ip_addresses_attributes: [:id, :ip_address, :_destroy])
		end
end
