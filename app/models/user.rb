require 'bcrypt'
require 'zlib'

class User < ActiveRecord::Base
	include BCrypt

	validates_uniqueness_of :username, :message => "already exists."

	validates_presence_of	:username, :message => "can't be empty."

	validates_presence_of	:password_hash, :message => "can't be empty."

	#validates :email, email: true

	before_create :create_remember_token
	has_many :movies
	has_many :stepups	
	has_one :context

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def password
    	@password ||= Password.new(password_hash)
	end

	def password=(new_password)
		@password = Password.create(new_password)
		self.password_hash = @password
	end

	def check_totp(one_time_password)
		base32 	= Base32.encode(username).tr("=", "")
		totp 	= ROTP::TOTP.new(base32)

		totp.now == one_time_password
	end

	def get_totp
		base32 	= Base32.encode(username).tr("=", "")
		totp 	= ROTP::TOTP.new(base32).now
	end

	# Check context of user
	def check_context(current_context)
		check_time(current_context[0]) && check_ip(current_context[1]) && check_location(current_context[2])
	end

	def check_time(current_time)
		starting_time 	= context.starting_time
		ending_time		= context.ending_time

		if (starting_time.nil? || ending_time.nil? )
			return true
		else
			starting_time < current_time && current_time < ending_time
		end
	end

	def check_ip(ip_address)
		if (context.ip_addresses.empty?)
			return true
		else
			!Context.where(:id => context.id).includes(:ip_addresses).where("ip_addresses.ip_address" => ip_address).empty?
		end
	end

	def check_location(location)
		if (context.locations.empty?)
			return true
		else
			!Context.where(:id => context.id).includes(:locations).where("locations.location" => location).empty?
		end
	end


	def add_stepup(current_context)
		stepup 			= Stepup.new
		stepup.user_id 	= id
		
		if (!check_time(current_context[0]))
			stepup.time 	= round_to_next_hour(current_context[0])
		end

		if (!check_ip(current_context[1]))
			stepup.ip 		= current_context[1]
		end

		if (!check_location(current_context[2]))		
			
			if (current_context[2] == "Unknown")
				stepup.location = nil
			else
				stepup.location = current_context[2]
			end

		end

		stepup.save
	end


	def round_to_next_hour(time)

		hours_int = time[0..1].to_i
		new_hours_int = hours_int + 1
		if (new_hours_int.to_s.size == 1)
			new_time = "0" + new_hours_int.to_s + ":00:00"
		elsif (new_hours_int == 24)
			new_time = "00:00:00"
		else
			new_time = new_hours_int.to_s + ":00:00"
		end

	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
