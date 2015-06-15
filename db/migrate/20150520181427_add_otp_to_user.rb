class AddOtpToUser < ActiveRecord::Migration
  def change
  	add_column :movies, :otp, :integer
  end
end
