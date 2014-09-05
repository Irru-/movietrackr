class User < ActiveRecord::Base
	validates_uniqueness_of :username
	validates_presence_of :password
	include BCrypt
	before_create :create_remember_token
	has_many :movies

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

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
