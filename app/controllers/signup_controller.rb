class SignupController < ApplicationController
	before_action :signed_in_user

	def index
		@user = User.new
	end

	private

		def signed_in_user
			redirect_to root_url if signed_in?
		end

end
