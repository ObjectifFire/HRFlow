class Api::V1::EmployeesController < ApplicationController
  before_action :set_company, only: [:index], if: -> { params[:company_id].present? }
  before_action :set_employee, only: [:show]

    def index
      employees = @company ? @company.employees : Employee.all
      render json: employees.as_json(only: [:email, :first_name, :last_name, :country]), status: :ok
    end

    def show
      render json: @employee.as_json(only: [:email, :first_name, :last_name, :country]), status: :ok
    end

    private

    def set_company
      @company = Company.find_by(id: params[:company_id])
      render json: { error: 'Company not found' }, status: :not_found unless @company
    end

    def set_employee
      @employee = Employee.find_by(id: params[:id])
      render json: { error: 'Employee not found' }, status: :not_found unless @employee
    end
end
