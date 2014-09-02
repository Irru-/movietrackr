class MoviesController < ApplicationController
	def new
		@movie = Movie.new
	end

	def index
		@movies = Movie.order('rating DESC')
	end

	def show
		@movie = Movie.find(params[:id])
	end

	def create
		swap_date(movie_params)
		@movie = Movie.new(movie_params)
		if @movie.save
			redirect_to '/movies/list'
		else
			render 'new'
		end
	end

	def destroy
		Movie.find(params[:id]).destroy
		redirect_to '/movies/list'

	end

	private

		def movie_params
			params.require(:movie).permit(:title, :rating, :saw_movie_at, :comment)
		end

		def swap_date(movie_params)
			temp = movie_params["saw_movie_at(1i)"]
			movie_params["saw_movie_at(1i)"] = movie_params["saw_movie_at(3i)"]
			movie_params["saw_movie_at(3i)"] = temp
			movie_params
		end
end
