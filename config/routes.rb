Rails.application.routes.draw do

  root 'home#index'

  get "/index", to: "items#index"
  resources :items, only: [:show, :index]

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

  #get 'signup', to: 'users#new'
  #post 'signup', to: 'users#create'

  resources :lenders

  resources :borrowers

  resources :users, only: [:show]

  namespace 'admin' do
    get '/', to: 'dashboard#index', as: '/'
    resources :items
    resources :categories
  end

end
