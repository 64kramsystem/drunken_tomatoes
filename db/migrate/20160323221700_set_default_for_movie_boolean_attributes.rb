class SetDefaultForMovieBooleanAttributes < ActiveRecord::Migration

  def change
    change_column :movies, :watched,   :boolean, null: false, default: false
    change_column :movies, :ignore,    :boolean, null: false, default: false
    change_column :movies, :watchlist, :boolean, null: false, default: false
  end

end
