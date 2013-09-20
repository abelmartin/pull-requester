PullRequester::Application.routes.draw do
  resources :watches

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  match '/ping' => 'home#ping', via: :get

  root to: "home#index"
end
