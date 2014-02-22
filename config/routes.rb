PullRequester::Application.routes.draw do
  resources :repositories do
    member do
      put :assign_user
    end
  end

  resource :account, only: [:show, :update]

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  match '/ping' => 'home#ping', via: :get

  root to: "home#index"
end
