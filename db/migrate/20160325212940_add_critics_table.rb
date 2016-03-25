class AddCriticsTable < ActiveRecord::Migration

  def change
    create_table :critics do |t|
      t.string :url_path, limit: 60, null: false
      t.string :name, null: false
    end

    add_index :critics, :url_path, unique: true
  end

end
