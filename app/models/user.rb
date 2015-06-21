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

	# Check context of user
	def check_context(ip_address, location)
		check_time && check_ip(ip_address) && check_location(location)
	end

	def check_time		
		starting_time 	= context.starting_time
		ending_time		= context.ending_time
		current_time	= Time.zone.now.to_s.split(" ")[1]

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

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
