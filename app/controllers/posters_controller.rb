class PostersController < ApplicationController

  def show
  	movie = Movie.find( params[ :movie_id ] )
  	send_data movie.poster, type: 'image/jpeg', disposition: 'inline'
  end

end
