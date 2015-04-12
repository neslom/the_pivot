Rails.application.routes.draw do

  root 'home#index'

  get "/browse", to: "loan_requests#index"

  get "/portfolio", to: "lender_portfolio#show"

  resources :loan_requests

  resources :categories do
    resources :items, only: [:show, :index]
  end

  get "/cart", to: "cart#index"
  post "/cart", to: "cart#create"
  delete "/cart", to: "cart#delete"
  put "/cart", to: "cart#update"

  resources :orders, only: [:create, :index, :show, :update]

  get "/login", to: "sessions#new", :as => "login"
  post "/login", to: "sessions#create"
  get "/logout", to: 'sessions#destroy'
  delete "/logout", to: 'sessions#destroy'

  resources :lenders

  resources :borrowers

  resources :users, only: [:show]

  namespace 'admin' do
    get '/', to: 'dashboard#index', as: '/'
    resources :items
    resources :categories
  end

end
