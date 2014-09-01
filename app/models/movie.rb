class Movie < ActiveRecord::Base
	validates :rating, :numericality => {:only_integer => true}
end
