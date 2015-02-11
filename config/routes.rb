Rails.application.routes.draw do

  get 'movies', to: 'movies#index'
  get 'posters/show', to: 'posters#show'

end
