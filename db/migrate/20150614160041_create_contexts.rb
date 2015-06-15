class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
    	t.belongs_to :user, index: true

    	t.time 		:starting_time
    	t.time 		:ending_time
    	t.string 	:location
    	t.string 	:ip_address
    	
      t.timestamps
    end
  end
end
