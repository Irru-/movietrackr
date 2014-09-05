module BeforeFilter

	def self.included(base)
    	base.before_filter :admin_user
  	end



		def admin_user
			redirect_to '/movies' unless current_user.admin
		end

		def user_params
			params.require(:user).permit(:username, :password)
		end

		def signed_in_user
      		redirect_to signin_url unless signed_in?
    	end

    	def correct_user
    		@user = User.find(params[:id])
    		redirect_to(root_url) unless current_user?(@user)
    	end

end