# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160325214813) do

  create_table "critics", force: :cascade do |t|
    t.string "url_path", limit: 60,  null: false
    t.string "name",     limit: 255, null: false
  end

  add_index "critics", ["url_path"], name: "index_critics_on_url_path", unique: true, using: :btree

  create_table "directors", force: :cascade do |t|
    t.string "url_path", limit: 128, null: false
    t.string "name",     limit: 255, null: false
  end

  add_index "directors", ["url_path"], name: "url_path", unique: true, using: :btree

  create_table "directors_movies", id: false, force: :cascade do |t|
    t.integer "director_id", limit: 3, null: false
    t.integer "movie_id",    limit: 4, null: false
  end

  add_index "directors_movies", ["director_id", "movie_id"], name: "director_id", unique: true, using: :btree
  add_index "directors_movies", ["movie_id", "director_id"], name: "movie_id", unique: true, using: :btree

  create_table "genres", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "genres_movies", id: false, force: :cascade do |t|
    t.integer "genre_id", limit: 1, null: false
    t.integer "movie_id", limit: 4, null: false
  end

  add_index "genres_movies", ["genre_id", "movie_id"], name: "genre_id", unique: true, using: :btree
  add_index "genres_movies", ["movie_id", "genre_id"], name: "movie_id", unique: true, using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",      limit: 255,                   null: false
    t.text     "synopsis",   limit: 65535,                 null: false
    t.integer  "rating",     limit: 1,                     null: false
    t.integer  "year",       limit: 4,                     null: false
    t.datetime "updated_on",                               null: false
    t.string   "url_path",   limit: 128,                   null: false
    t.boolean  "watched",                  default: false, null: false
    t.boolean  "ignore",                   default: false, null: false
    t.boolean  "watchlist",                default: false, null: false
  end

  add_index "movies", ["url_path"], name: "url_path", unique: true, using: :btree

  create_table "posters", force: :cascade do |t|
    t.binary "data", limit: 16777215, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text    "link",      limit: 16777215, null: false
    t.integer "movie_id",  limit: 4,        null: false
    t.integer "critic_id", limit: 4,        null: false
  end

  add_index "reviews", ["critic_id"], name: "index_reviews_on_critic_id", using: :btree
  add_index "reviews", ["movie_id"], name: "movie_id", using: :btree

  create_table "trailers", force: :cascade do |t|
    t.text    "link",     limit: 16777215, null: false
    t.string  "title",    limit: 255
    t.integer "movie_id", limit: 4,        null: false
  end

  add_index "trailers", ["movie_id"], name: "movie_id", using: :btree

end
