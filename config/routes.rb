Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :companies do
        resources :employees, only: [:index]
      end

      resources :employees, only: [:index, :show] do
        resources :leave_requests, only: [:index]
      end

      resources :leave_requests, only: [:index, :show, :create]
    end
  end
end
