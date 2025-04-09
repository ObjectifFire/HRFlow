module Api
  module V1
    class CompaniesEmployeesController < ApplicationController
      before_action :set_company_by_siret
      before_action :set_employee_by_employee_hr_id, only: [:create, :destroy]

      def index
        employees = @company.employees.ordered_by_name

        render json: employees.map { |employee|
          employee.as_json(only: [:first_name, :last_name, :email, :country, :employee_hr_id]).merge(
            company_name: @company.name
          )
        }, status: :ok
      end

      def create
        if @employee.companies.exists?
          render json: { error: "Employee is already assigned to a company" }, status: :unprocessable_entity
        else
          @company.employees << @employee
          render json: { message: "Employee assigned" }, status: :created
        end
      end

      def destroy
        if @company.employees.exists?(@employee.id)
          @company.employees.destroy(@employee)
          head :no_content
        else
          render json: { error: "Employee not assigned to this company" }, status: :not_found
        end
      end

      private

      def set_company_by_siret
        @company = Company.find_by(siret: params[:company_siret] || params[:siret])
        render json: { error: "Company not found" }, status: :not_found unless @company
      end

      def set_employee_by_employee_hr_id
        @employee = Employee.find_by(employee_hr_id: params[:employee_hr_id])
        render json: { error: "Employee not found" }, status: :not_found unless @employee
      end
    end
  end
end
