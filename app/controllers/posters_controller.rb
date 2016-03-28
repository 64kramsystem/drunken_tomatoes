class PostersController < ApplicationController

  def show
  	poster = Poster.find( params[ :movie_id ] )
  	send_data poster.data, type: 'image/jpeg', disposition: 'inline'
  end

end
