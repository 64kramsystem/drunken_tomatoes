class SetRatingToNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :movies, :rating, :integer, null: true
  end
end
