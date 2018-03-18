module MoviesHelper
  MOVIES_PER_PAGE = 30

  SORT_MAPPING = {
    "Release date" => "year",
    "Rating"       => "rating",
  }.freeze

  ANNOTATIONS = %w[watched watchlist ignore].freeze

  RATINGS = 10.step(100, 10).to_a

  YEARS = 1920.step(Date.today.year / 10 * 10, 10).to_a

  DEFAULT_MIN_REVIEWS = 10
  DEFAULT_SORTING = SORT_MAPPING.fetch("Release date")

  # Output format:
  #
  #   "document.location = '/movies' + '?title_pattern=' + movie_title_pattern.value + '&genre_id=' + ..."
  #
  def js_on_change_link
    link_params = {
      'title_pattern' => 'movie_title_pattern.value',
      'genre_id' => 'movie_genre_id.value',
      'sorting_field' => 'sorting_field.value',
      'min_rating' => 'movie_min_rating.value',
      'min_year' => 'movie_min_year.value',
      'watchable' => 'movie_watchable.checked',
      'min_reviews' => 'movie_min_reviews.value',
    }

    link_param_strings = link_params.each_with_index.map do |(field, value), i|
      separator = i == 0 ? "?" : "&"
      "'#{separator}#{field}=' + #{value}"
    end

    "document.location = '/movies' + " + link_param_strings.join(" + ")
  end

  def new_page_params
    {
      title_pattern: @title_pattern,
      genre_id: @genre_id,
      sorting_field: @sorting_field,
      min_rating: @min_rating,
      min_year: @min_year,
      watchable: @watchable,
    }
  end

  private

  # Returns [annotation, true/false] if there is an annotation in the params.
  #
  def extract_annotation_from_params
    ANNOTATIONS.each do |annotation|
      if params.key?(annotation) && %(true false).include?(params[annotation])
        annotation_value = params[annotation] == "true"
        return [annotation, annotation_value]
      end
    end

    nil
  end
end
