class MoviesController < ApplicationController
	before_action :signed_in_user, only: [:new, :own]

	def new
		@movie = Movie.new
	end

	def index

		@id = Movie.sorteer_decide_i(params[:sorteer])
		@title = Movie.sorteer_decide_t(params[:sorteer])
		@rating = Movie.sorteer_decide_r(params[:sorteer])
		@username = Movie.sorteer_decide_u(params[:sorteer])

		if signed_in?
			@own_movies = Movie.where(user_id: current_user.id)
		end

		if params[:sorteer].present?
			@movies = Movie.sorteer(params[:sorteer])
		else
			@movies = Movie.order('id ASC')
		end

		if params[:url].present?
			movie = Movie.find(params[:id])
			movie.imdb = params[:url]
			movie.title = params[:title]
			movie.save
			redirect_to '/movies/'
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

	def own
		@movies = Movie.where(user_id: current_user.id)
		if @movies.nil?
			@movies = @movie.order('rating DESC')
		end
	end

	def search
		bf = BadFruit.new("7y3ev7dshky24eynky3apa4m")
		@result = bf.movies.search_by_name(params[:title], 10)
	end

	def destroy
		Movie.find(params[:id]).destroy
		redirect_to '/movies/'

	end

	def reset
		Movie.delete_all
		User.delete_all

		redirect_to root_url
	end

	private

		def movie_params
			params.require(:movie).permit(:title, :rating, :saw_movie_at, :comment, :user_id, :imdb)
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
