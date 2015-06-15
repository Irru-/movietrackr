class RemoveOtpFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :RemoveOtpFromUsers
  end
end
