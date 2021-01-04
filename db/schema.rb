# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_04_105613) do

  create_table "annotations", force: :cascade do |t|
    t.boolean "watched", default: false, null: false
    t.boolean "ignore", default: false, null: false
    t.boolean "watchlist", default: false, null: false
  end

  create_table "critics", force: :cascade do |t|
    t.string "url_path", null: false
    t.string "name", null: false
    t.index ["url_path"], name: "index_critics_on_url_path", unique: true
  end

  create_table "directors", force: :cascade do |t|
    t.string "url_path", null: false
    t.string "name", null: false
    t.index ["url_path"], name: "index_directors_on_url_path", unique: true
  end

  create_table "directors_movies", id: false, force: :cascade do |t|
    t.integer "director_id", null: false
    t.integer "movie_id", null: false
    t.index ["director_id", "movie_id"], name: "index_directors_movies_on_director_id_and_movie_id", unique: true
    t.index ["movie_id", "director_id"], name: "index_directors_movies_on_movie_id_and_director_id", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "genres_movies", id: false, force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "movie_id", null: false
    t.index ["genre_id", "movie_id"], name: "index_genres_movies_on_genre_id_and_movie_id", unique: true
    t.index ["movie_id", "genre_id"], name: "index_genres_movies_on_movie_id_and_genre_id", unique: true
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.text "synopsis", null: false
    t.integer "rating"
    t.datetime "updated_on", null: false
    t.string "url_path", null: false
    t.integer "general_reviews_count", null: false
    t.string "first_release_date", null: false
    t.index ["url_path"], name: "index_movies_on_url_path", unique: true
  end

  create_table "posters", force: :cascade do |t|
    t.binary "data", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "link", null: false
    t.integer "movie_id", null: false
    t.integer "critic_id", null: false
    t.index ["critic_id"], name: "index_reviews_on_critic_id"
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
  end

  create_table "trailers", force: :cascade do |t|
    t.string "link", null: false
    t.string "title"
    t.integer "movie_id", null: false
    t.index ["movie_id"], name: "index_trailers_on_movie_id"
  end

end
