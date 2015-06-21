class CreateStepups < ActiveRecord::Migration
  def change
    create_table :stepups do |t|
    	t.belongs_to	:user
    	t.string		:ip
    	t.string		:location
    	t.string		:time
      t.timestamps
    end
  end
end
