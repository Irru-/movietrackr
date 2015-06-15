class AdminController < ApplicationController
	before_action :signed_in_user
	before_action :admin_user

	def index
		@users = User.all
	end

	private

		def admin_user
			#redirect_to '/movies' unless current_user.admin
		end

		def signed_in_user
			#redirect_to '/movies' unless signed_in?
		end

end

#I editted this!
