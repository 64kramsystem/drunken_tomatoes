class MoviesController < ApplicationController

  MOVIES_PER_PAGE = 30

  SORT_MAPPING = {
    'Release date' => 'year',
    'Rating'       => 'rating',
  }

  def index
    page           = int_param( :page ) || 1
    @genre_id      = int_param( :genre_id )
    @sorting_field = whitelist_param( :sorting_field, SORT_MAPPING.values )

    @movies = Movie.page( page ).per( MOVIES_PER_PAGE )
    @movies = @movies.joins( :genres ).where( genres: { id: @genre_id } ) if @genre_id
    @movies = @movies.order( "#{ @sorting_field } DESC" ) if @sorting_field

    @genres = Genre.all

    @sort_mapping = SORT_MAPPING.clone
  end

end
