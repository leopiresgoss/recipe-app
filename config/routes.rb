Rails.application.routes.draw do
  resources :foods, only: %i[index new create destroy]
  resources :recipes, only: %i[index new create show destroy]
  resources :public_recipes, only: %i[index show]
  resources :general_shopping_list, only: %i[index]

  root 'public_recipes#index'
end
