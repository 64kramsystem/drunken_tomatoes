class AddMoviesGeneralReviewsCount < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :general_reviews_count, :integer
    Movie.update_all general_reviews_count: -1
    change_column :movies, :general_reviews_count, :integer, null: false
  end
end
