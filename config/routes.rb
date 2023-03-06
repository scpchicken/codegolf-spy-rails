Rails.application.routes.draw do

  put "main/query_login", to: "main#query_login", as: "query_login_page"
  put "update_db/update_main", to: "update_db#main", as: "update_main_page"
  put "update_db/update_db", to: "update_db#update_db", as: "update_db_page"

  root "main#main"
  # root "posts#index"

  # get "update_db/main"
  get "solution_spy/solution_spy"
  # get "solution_spy/solution_spy"
  

  resources :globals
  resources :solution_points
  resources :hole_points
  resources :lang_points
  resources :login
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
