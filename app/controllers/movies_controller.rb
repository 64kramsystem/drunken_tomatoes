class MoviesController < ApplicationController
  include MoviesHelper

  def index
    page           = int_param(:page) || 1
    @title_pattern = params[:title_pattern]
    @genre_id      = int_param(:genre_id)
    @sorting_field = whitelist_param(:sorting_field, SORT_MAPPING.values) || DEFAULT_SORTING
    @min_rating    = int_param(:min_rating)
    @min_year      = int_param(:min_year)
    @watchable     = boolean_param(:watchable) || boolean_param(:watchable).nil?
    @min_reviews   = int_param(:min_reviews) || DEFAULT_MIN_REVIEWS

    # Note that if `watchable` is selected, we first sort by `watchlist` attribute.
    #
    @movies = Movie.page(page).per(MOVIES_PER_PAGE)
    @movies = @movies.where("title LIKE ?", "%#{@title_pattern.strip}%") if @title_pattern
    @movies = @movies.where("general_reviews_count >= ?", @min_reviews)
    @movies = @movies.joins(:genres).where(genres: {id: @genre_id}) if @genre_id
    @movies = @movies.where("rating >= ?", @min_rating) if @min_rating
    @movies = @movies.where("first_release_date >= ?", "#{@min_year}-01-01") if @min_year
    @movies = @movies.joins(:annotation).where(annotations: {watched: false, ignore: false}).order("watchlist DESC") if @watchable
    @movies = @movies.order("#{@sorting_field} DESC") if @sorting_field

    @genres = Genre.all
  end

  def show
    respond_to do |format|
      format.js do
        movie = Movie.find(params[:id])

        partial_name = params[:details] == "true" ? "_details_panel" : "_poster_panel"

        panel_content = render_to_string(partial_name, layout: false, locals: {movie: movie})

        render json: {id: params[:id], panel_content: panel_content}, content_type: "text/json"
      end
    end
  end

  def update
    respond_to do |format|
      format.js do
        annotation, annotation_value = extract_annotation_from_params

        if annotation
          movie = Movie.find(params[:id])
          movie.annotation.update!(annotation => annotation_value)

          annotation_link_locals = {movie: movie, annotation: annotation, value: annotation_value}
          annotation_link = render_to_string("_annotation_link", layout: false, locals: annotation_link_locals)

          render json: {id: params[:id], annotation: annotation, link: annotation_link}, content_type: "text/json"
        else
          head :ok
        end
      end
    end
  end
end
