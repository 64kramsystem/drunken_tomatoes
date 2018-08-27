class DropMoviesYear < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :year
  end
end
