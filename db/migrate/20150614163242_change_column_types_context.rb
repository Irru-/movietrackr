class ChangeColumnTypesContext < ActiveRecord::Migration
  def change
  	remove_column :contexts, :starting_time
  	remove_column :contexts, :ending_time

  	add_column :contexts, :starting_time, :string
  	add_column :contexts, :ending_time, :string
  end
end
