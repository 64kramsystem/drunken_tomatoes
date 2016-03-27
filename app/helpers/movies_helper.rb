module MoviesHelper

  def annotation_link(movie, annotation, value)
    helpers = ActionController::Base.helpers

    icon_name = "#{ annotation }#{ '_unchecked' if ! value }.png"
    path_with_annotation = movie_path(movie, annotation => ! value)

    helpers.link_to helpers.image_tag( icon_name, size: "16" ), path_with_annotation, method: :put, remote: true
  end

end
