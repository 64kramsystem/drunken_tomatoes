class SetRatingToNullable < ActiveRecord::Migration

  def change
    change_column :movies, :rating, :integer, null: true
  end

end
