Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :commitments, only: %i[index create show update]

      post   "/login",  to: "auth#login"
      delete "/logout", to: "auth#logout"
      get    "/me",     to: "users#me"
    end
  end
end
