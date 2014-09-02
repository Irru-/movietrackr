class ChangeColumnTypeAgain < ActiveRecord::Migration
  def change
  	change_column :movies, :saw_movie_at, :date
  end
end
