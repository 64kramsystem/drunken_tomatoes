class MoviesController < ApplicationController

  MOVIES_PER_PAGE = 30

  SORT_MAPPING = {
    'Release date' => 'year',
    'Rating'       => 'rating',
  }

  ANNOTATIONS = %w[watched watchlist ignore]

  RATINGS = 10.step(100, 10).to_a

  YEARS = 1920.step(Date.today.year / 10 * 10, 10).to_a

  def index
    page           = int_param( :page ) || 1
    @genre_id      = int_param( :genre_id )
    @sorting_field = whitelist_param( :sorting_field, SORT_MAPPING.values )
    @min_rating    = int_param( :min_rating )
    @min_year      = int_param( :min_year )
    @watchable     = boolean_param( :watchable ) || boolean_param( :watchable ).nil?

    # Note that if `watchable` is selected, we first sort by `watchlist` attribute.
    #
    @movies = Movie.page( page ).per( MOVIES_PER_PAGE )
    @movies = @movies.joins( :genres ).where( genres: { id: @genre_id } ) if @genre_id
    @movies = @movies.where( 'rating >= ?', @min_rating ) if @min_rating
    @movies = @movies.where( 'year >= ?', @min_year ) if @min_year
    @movies = @movies.joins(:annotation).where( annotations: {watched: false, ignore: false} ).order('watchlist DESC') if @watchable
    @movies = @movies.order( "#{ @sorting_field } DESC" ) if @sorting_field

    @genres = Genre.all
    @sort_mapping = SORT_MAPPING.clone
    @annotations = ANNOTATIONS
    @ratings = RATINGS
    @years = YEARS
  end

  def show
    respond_to do |format|
      format.js do
        movie = Movie.find(params[:id])

        partial_name = params[:details] == 'true' ? '_details_panel' : '_poster_panel'

        panel_content = render_to_string(partial_name, layout: false, locals: { movie: movie } )

        render json: { id: params[:id], panel_content: panel_content }, content_type: 'text/json'
      end
    end
  end

  def update
    respond_to do |format|
      format.js do
        ANNOTATIONS.each do |annotation|
          if params.has_key?(annotation) && %[true false].include?(params[annotation])
            movie = Movie.find(params[:id])
            annotation_value = params[annotation] == 'true'

            movie.annotation.update_attributes!(annotation => annotation_value)

            annotation_link = render_to_string('_annotation_link', layout: false, locals: { movie: movie, annotation: annotation, value: annotation_value } )
            render json: { id: params[:id], annotation: annotation, link: annotation_link }, content_type: 'text/json'

            return
          end
        end

        head :ok
      end
    end
  end

end
