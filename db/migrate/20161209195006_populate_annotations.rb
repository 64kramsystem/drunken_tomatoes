class PopulateAnnotations < ActiveRecord::Migration[5.0]
  def change
    sql = "
      INSERT INTO annotations(id, watched, ignore, watchlist)
      SELECT id, watched, ignore, watchlist
      FROM movies
    "

    connection.update(sql)
  end
end
