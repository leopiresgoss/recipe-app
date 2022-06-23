Rails.application.routes.draw do
  devise_for :users
  resources :foods, only: %i[index new create destroy]
  resources :recipes, only: %i[index new create show destroy update] do
    resources :recipe_foods, except: %i[show]
  end
  resources :public_recipes, only: %i[index show]
  resources :general_shopping_list, only: %i[index]

  get '/users', to: 'recipes#index'

  root 'public_recipes#index'
end
