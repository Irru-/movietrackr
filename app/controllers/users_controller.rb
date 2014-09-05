	class UsersController < ApplicationController
	before_action :signed_in_user, 	only: [:index, :show, 	:edit, :update]
	before_action :correct_user,   	only: [:edit, :update]
	before_action :admin_user,		only: [:index, :show]

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to '/movies'
		else
			render 'edit'
		end
	end

	def create
		@user = User.new(user_params)
		@user.password = params[:password]
		if @user.save
			sign_in @user
			redirect_to '/movies'
		else
			redirect_to '/movies'
		end
	end

	def destroy
		user = User.find(params[:id])
		user.delete
		redirect_to '/movies'
	end

	private

		def admin_user
			redirect_to '/movies' unless current_user.admin
		end

		def user_params
			params.require(:user).permit(:username, :password_hash)
		end

		def signed_in_user
      		redirect_to signin_url unless signed_in?
    	end

    	def correct_user
    		@user = User.find(params[:id])
    		redirect_to(root_url) unless current_user?(@user)
    	end
end
