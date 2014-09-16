require 'imdb'

class Movie < ActiveRecord::Base
	validates :rating, :numericality => {:only_integer => true}
	belongs_to :user

	scope :order_by_user_asc, lambda { joins("LEFT JOIN users ON movies.user_id = users.id").order("users.username ASC") }
	scope :order_by_user_desc, lambda { joins("LEFT JOIN users ON movies.user_id = users.id").order("users.username DESC") }

	def self.sorteer(sort_on)

		logger.debug "sort_on -> #{sort_on}"

		case sort_on
		when 'id'
			order('id ASC')
		when 'id_'
			order('id DESC')
		when 'title'
			order('title ASC')
		when 'title_'
			order('title DESC')
		when 'rating'
			order('rating ASC')
		when 'rating_'
			order('rating DESC')
		when 'username'
			order_by_user_asc
		when 'username_'
			order_by_user_desc
		else
			order('id ASC')
		end

	end	

	def self.sorteer_decide_i(p)

		p == 'id' ? 'id_' : 'id'

	end

	def self.sorteer_decide_t(p)

		p == 'title' ? 'title_' : 'title'

	end

	def self.sorteer_decide_r(p)

		p == 'rating' ? 'rating_' : 'rating'

	end

	def self.sorteer_decide_u(p)

		p == 'username' ? 'username_' : 'username'

	end

	def addImdbLink(title)
		i = Imdb::Search.new(title)
		i.movies.first.url
	end

end
