Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :commitments, only: %i[index create show update]

      post   "/login",  to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      get    "/me",     to: "users#me"
    end
  end
end
