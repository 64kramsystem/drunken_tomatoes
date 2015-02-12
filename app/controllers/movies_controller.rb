class MoviesController < ApplicationController

  MOVIES_PER_PAGE = 30

  def index
    @movies = Movie.page( param_page ).per( MOVIES_PER_PAGE )
  end

  private

  def param_page
    case params[ :page ]
    when nil
      1
    when /\A\d+\Z/
      params[ :page ].to_i
    else
      raise "Invalid page parameter!"
    end
  end

end
