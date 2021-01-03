class UpdateAnnotationBooleanValues < ActiveRecord::Migration[5.2]
  def change
    rename_table :annotations, :annotations_bak

    create_table "annotations", force: :cascade do |t|
      t.boolean "watched",   default: false, null: false
      t.boolean "ignore",    default: false, null: false
      t.boolean "watchlist", default: false, null: false
    end

    connection.update "
      INSERT INTO annotations(id, watched, ignore, watchlist)
      SELECT
        id,
        CASE WHEN watched   = 't' THEN 1 ELSE 0 END,
        CASE WHEN ignore    = 't' THEN 1 ELSE 0 END,
        CASE WHEN watchlist = 't' THEN 1 ELSE 0 END
      FROM annotations_bak
    "

    drop table :annotations_bak
  end
end
