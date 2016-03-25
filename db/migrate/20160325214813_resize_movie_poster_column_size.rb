class ResizeMoviePosterColumnSize < ActiveRecord::Migration

  def change
    change_column :movies, :poster, :binary, limit: 64.kilobytes, null: false
  end

end
