class AddFirstReleaseDateToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :first_release_date, :string, null: false
  end
end
