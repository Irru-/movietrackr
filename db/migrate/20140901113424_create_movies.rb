class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
	t.string	:title
	t.datetime	:saw_movie_at
	t.integer	:rating
	t.text		:comment
      	t.timestamps
    end
  end
end
