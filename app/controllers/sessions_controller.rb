require 'bcrypt'

class SessionsController < ApplicationController
    include BCrypt

    def new
    end

    def create
        @user = User.find_by(username: params[:session][:username])
        @user = User.find_by(email: params[:session][:username]) if @user.nil?
        pwcheck = params[:session][:password]
        otp     = params[:session][:otp]
        if (!@user.nil? && @user.password == pwcheck)
            #Context check here
            
            location = request.location
            current_time = Time.zone.now.to_s.split(" ")[1]
            ip = request.remote_ip
            if (location.nil?)
                location = "Unknown"
            else
                location = location.city
            end

            context = [current_time, ip, location]

            if (@user.check_context(context))
                sign_in @user
                redirect_to root_url
            else
                if (otp.nil?)                   
                    redirect_to stepup_path(:user => @user.username)
                else
                    if (@user.check_totp(otp))
                        @user.add_stepup(context)
                        sign_in @user
                        redirect_to root_url
                    else
                        flash[:error] = "Wrong One-Time Password. Please try again."
                        redirect_to stepup_path                        
                    end
                end
            end
        else
            flash[:error] = "Wrong username/password combination. Please try again."
            redirect_to root_url
        end
    end

    def stepup
        @test = request.remote_ip
    end

    def destroy
        sign_out
        redirect_to root_url
    end
end
