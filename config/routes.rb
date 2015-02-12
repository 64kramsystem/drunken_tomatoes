Rails.application.routes.draw do

  get '/', to: 'movies#index'
  get 'movies', to: 'movies#index'
  get 'posters/show', to: 'posters#show'

end
