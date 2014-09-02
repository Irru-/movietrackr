class ChangeColumnTypeMovies < ActiveRecord::Migration
  def up
  	change_column :movies, :saw_movie_at, :datetime
  end

  def down
  	change_column :movies, :saw_movie_at, :date
  end
end

