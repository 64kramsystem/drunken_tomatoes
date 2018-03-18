class AddAnnotationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :annotations do |t|
      t.boolean  :watched,   default: false, null: false
      t.boolean  :ignore,    default: false, null: false
      t.boolean  :watchlist, default: false, null: false
    end
  end
end
