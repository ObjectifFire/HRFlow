class Api::V1::EmployeesController < ApplicationController
  before_action :set_company, only: [ :index ], if: -> { params[:company_id].present? }

    def index
      employees = @company ? @company.employees : Employee.all
      render json: employees.as_json(only: [ :email, :first_name, :last_name, :country ]), status: :ok
    end

    def create
      employee = Employee.new(employee_params)

      if employee.save
        render json: employee.as_json(only: [ :first_name, :last_name, :email, :country ]), status: :created
      else
        render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @employee = Employee.find_by(id: params[:id])

      unless @employee
        return render json: { error: "Employee not found" }, status: :not_found
      end

      if @employee.destroy
        head :no_content
      else
        render json: { error: "Failed to delete employee" }, status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = Company.find_by(id: params[:company_id])
      render json: { error: "Company not found" }, status: :not_found unless @company
    end

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :country)
    end
end
