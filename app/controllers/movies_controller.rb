class MoviesController < ApplicationController
	before_action :signed_in_user, only: [:new]

	def new
		@movie = Movie.new
	end

	def index
		if signed_in?
			#@movies = Movie.where(user_id: current_user.id)
			@movies = Movie.order('rating DESC')
		else
			@movies = Movie.order('rating DESC')
		end
	end

	def show
		@movie = Movie.find(params[:id])
	end

	def create
		swap_date(movie_params)
		@movie = Movie.new(movie_params)
		@movie[:user_id] = current_user.id
		if @movie.save
			redirect_to '/movies/'
		else
			render 'new'
		end
	end

	def destroy
		Movie.find(params[:id]).destroy
		redirect_to '/movies/'

	end

	private

		def movie_params
			params.require(:movie).permit(:title, :rating, :saw_movie_at, :comment, :user_id)
		end

		def swap_date(movie_params)
			temp = movie_params["saw_movie_at(1i)"]
			movie_params["saw_movie_at(1i)"] = movie_params["saw_movie_at(3i)"]
			movie_params["saw_movie_at(3i)"] = temp
			movie_params
		end

		def signed_in_user
			redirect_to signin_url unless signed_in?
		end
end
