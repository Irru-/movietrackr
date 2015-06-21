class RemoveColumnsFromContext < ActiveRecord::Migration
  def change
  	remove_column :contexts, :location
  	remove_column :contexts, :ip_address
  end
end
