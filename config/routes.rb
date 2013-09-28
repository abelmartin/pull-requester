PullRequester::Application.routes.draw do
  resources :watches
  resource :account, only: [:show, :update]

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  match '/ping' => 'home#ping'
  get '/repositories' => 'watches#repositories', as: :repositories
  put '/repositories' => 'watches#update_repositories', as: :update_repositories

  root to: "home#index"
end
