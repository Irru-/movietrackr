class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
    	t.belongs_to	:context
    	t.string		:ip_address
      t.timestamps
    end
  end
end
