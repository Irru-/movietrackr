class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.belongs_to	:context
    	t.string		:location
      t.timestamps
    end
  end
end
