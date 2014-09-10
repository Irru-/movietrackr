require 'bcrypt'

class SessionsController < ApplicationController
	include BCrypt

	def new
	end

	def create
		@user = User.find_by(username: params[:session][:username])
		if @user.nil?
			logger.debug "@user.class = #{@user.class}"
			@user = User.find_by(email: params[:session][:username])
			logger.debug "@user.email = #{@user.email}"
		end
		pwcheck = params[:session][:password]
		if (!@user.nil? && @user.password == pwcheck)
			sign_in @user
			redirect_to root_url
		else
      		render 'new'
		end
	end

	def destroy
		sign_out
    	redirect_to root_url
	end
end
