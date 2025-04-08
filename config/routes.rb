Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :companies, only: [:index]

      resources :employees, only: [:index, :create, :destroy]
      patch "/employees/:id/company", to: "employees#update_company" 

      get    "/companies/:company_id/employees", to: "companies_employees#index"
      post   "/companies/:company_id/employees/:employee_id", to: "companies_employees#create"
      delete "/companies/:company_id/employees/:employee_id", to: "companies_employees#destroy"

      resources :leave_requests, only: [:create] do
        collection do
          get "pending", to: "leave_requests#pending"
        end
        member do
          delete "cancel", to: "leave_requests#cancel"
        end
      end

      namespace :admin do
        resources :companies, only: [:index]
        resources :employees, only: [:index, :create, :destroy]

        post   "/companies/:company_id/employees/:employee_id", to: "companies_employees#create"
        delete "/companies/:company_id/employees/:employee_id", to: "companies_employees#destroy"

        resources :leave_requests, only: [:create, :update]
      end
    end
  end
end
