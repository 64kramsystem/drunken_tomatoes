class MoviesController < ApplicationController

  include MoviesHelper

  MOVIES_PER_PAGE = 30

  SORT_MAPPING = {
    'Release date' => 'year',
    'Rating'       => 'rating',
  }

  ANNOTATIONS = %w[watched watchlist ignore]

  def index
    page           = int_param( :page ) || 1
    @genre_id      = int_param( :genre_id )
    @sorting_field = whitelist_param( :sorting_field, SORT_MAPPING.values )

    @movies = Movie.page( page ).per( MOVIES_PER_PAGE )
    @movies = @movies.joins( :genres ).where( genres: { id: @genre_id } ) if @genre_id
    @movies = @movies.order( "#{ @sorting_field } DESC" ) if @sorting_field

    @genres = Genre.all

    @sort_mapping = SORT_MAPPING.clone
    @annotations = ANNOTATIONS
  end

  def update
    respond_to do |format|
      format.js do
        ANNOTATIONS.each do |annotation|
          if params.has_key?(annotation) && %[true false].include?(params[annotation])
            movie = Movie.find(params[:id])
            annotation_value = params[annotation] == 'true'

            movie.update_attributes!(annotation => annotation_value)

            render json: { id: params[:id], annotation: annotation, link: annotation_link(movie, annotation, annotation_value) }, content_type: 'text/json'

            return
          end
        end

        head :ok
      end
    end
  end

end
