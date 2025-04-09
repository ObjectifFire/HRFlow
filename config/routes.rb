Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :companies, only: [:index], param: :siret do
        get 'employees', to: 'companies_employees#index'
        post 'employees/:employee_hr_id', to: 'companies_employees#create', as: :add_employee
        delete 'employees/:employee_hr_id', to: 'companies_employees#destroy', as: :remove_employee
      end

      resources :employees, only: [:index, :create], param: :employee_hr_id
      delete '/employees/:employee_hr_id', to: 'employees#destroy'
      patch  '/employees/:employee_hr_id/company', to: 'employees#update_company'

      resources :leave_requests, only: [:create] do
        collection do
          get 'pending', to: 'leave_requests#pending'
        end
        member do
          delete 'cancel', to: 'leave_requests#cancel'
        end
      end

      namespace :admin do
        resources :companies, only: [:index], param: :siret do
          post 'employees/:employee_hr_id', to: 'companies_employees#create'
          delete 'employees/:employee_hr_id', to: 'companies_employees#destroy'
        end

        resources :employees, only: [:index, :create], param: :employee_hr_id
        delete '/employees/:employee_hr_id', to: 'employees#destroy'
        patch  '/employees/:employee_hr_id/company', to: 'employees#update_company'

        resources :leave_requests, only: [:create, :update]
      end

    end
  end
end
