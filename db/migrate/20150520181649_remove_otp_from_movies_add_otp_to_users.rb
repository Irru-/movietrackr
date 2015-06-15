class RemoveOtpFromMoviesAddOtpToUsers < ActiveRecord::Migration
  def change
  	remove_column :movies, :otp
  	add_column :users, :otp, :integer
  end
end
