class MoviesController < ApplicationController
	def new
		@movie = Movie.new
	end

	def all
		@movie = Movie.all
	end

	def create
		@movie = Movie.new(movie_params)
		if @movie.save
			redirect_to '/movies/list'
		else
			render 'new'
		end
	end

	private

		def movie_params
			params.require(:movie).permit(:title, :rating)
		end
end
