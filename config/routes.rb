Rails.application.routes.draw do
  resources :likes
  resources :spots
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "get_evaluation_Record" => "evaluations#getEvaluationRecord"
  get "evaluate_spot" => "spots#evaluate"
  get "search_spot" => "spots#search", as: :searchSpots
  get 'spots/getCoordinate/:id', to: "spots#getCoordinate", as: :get_coordinate
  post 'auth/:provider/callback', to: "users#create"
  get 'users/get_current_user/:uid', to: "users#getCurrentUser", as: :get_current_user
end
