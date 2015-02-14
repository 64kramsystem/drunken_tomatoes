class MoviesController < ApplicationController

  MOVIES_PER_PAGE = 30

  def index
    page      = int_param( :page ) || 1
    @genre_id = int_param( :genre_id )

    @movies = Movie.page( page ).per( MOVIES_PER_PAGE )
    @movies = @movies.joins( :genres ).where( genres: { id: @genre_id } ) if @genre_id

    @genres = Genre.all
  end

end
