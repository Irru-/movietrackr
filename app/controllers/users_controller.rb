class UsersController < ApplicationController
	before_action :signed_in_user, 	only: [:index, :show, :edit, :update]
	before_action :correct_user,   	only: [:edit, :update]
	before_action :admin_user,		only: [:index, :show]

	def index
		@user = User.find(current_user.id)
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def edit
		#@user = User.find(params[:id])
		@user = User.find(current_user.id)
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			@user.password = params[:user][:password]
			redirect_to '/movies'
		else
			render 'edit'
		end
	end

	def create
		@user 					= User.new(user_params)
		@user.password 			= params[:user][:password]

		if @user.save

			if (User.all.size == 1)
				@user.admin = true
			end

			context 			= Context.new
			context.user_id 	= @user.id
			context.save

			sign_in @user
			redirect_to '/movies'
		else
			flash[:error] = "Username or email already exists. Please try again."
            redirect_to root_url
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
			params.require(:user).permit(:username, :password, :password_hash, :email)
		end

		def signed_in_user
      		redirect_to signin_url unless signed_in?
    	end

    	def correct_user
    		@user = User.find(params[:id])
    		redirect_to(root_url) unless current_user?(@user)
    	end
end
