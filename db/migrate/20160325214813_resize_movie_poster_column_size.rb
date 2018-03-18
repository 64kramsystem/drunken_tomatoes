class ResizeMoviePosterColumnSize < ActiveRecord::Migration[5.0]
  def change
    change_column :movies, :poster, :binary, limit: 64.kilobytes, null: false
  end
end
