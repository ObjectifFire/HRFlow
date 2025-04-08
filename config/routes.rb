Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :companies do
        resources :employees, only: [:index]
      end

      resources :employees, only: [:index, :show] do
        resources :absences, only: [:index]
      end

      resources :absences, only: [:index, :show, :create]
    end
  end
end
