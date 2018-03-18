class RemoveAnnotationsFromMovies < ActiveRecord::Migration[5.0]
  def change
    remove_column :movies, :watched
    remove_column :movies, :ignore
    remove_column :movies, :watchlist
  end
end
