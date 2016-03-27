Rails.application.routes.draw do

  get '/', to: 'movies#index'
  resources :movies, only: %w[index update]
  get 'posters/show', to: 'posters#show'

end
