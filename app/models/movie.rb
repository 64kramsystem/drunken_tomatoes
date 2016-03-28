class Movie < ActiveRecord::Base

  has_and_belongs_to_many :genres
  has_one :poster, foreign_key: :id

end
