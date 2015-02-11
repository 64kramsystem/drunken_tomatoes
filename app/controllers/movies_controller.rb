class MoviesController < ApplicationController

  def index
  	@movies = Movie.all[ 0, 30 ]
  end

end
