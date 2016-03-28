module MoviesHelper

  def js_on_change_link
    "document.location = '/movies?genre_id=' + movie_genre_id.value + '&sorting_field=' + sorting_field.value"
  end

end
