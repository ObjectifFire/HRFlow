class Api::V1::EmployeesController < ApplicationController
  before_action :set_employee_by_hr_id, only: [ :destroy, :update_company ]

  def index
    employees = Employee.limit(50) # SHould add paginate results in near future
    render json: employees.as_json(only: [ :email, :first_name, :last_name, :country, :employee_hr_id ]), status: :ok
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
    if @employee.destroy
      head :no_content
    else
      render json: { error: "Failed to delete employee" }, status: :unprocessable_entity
    end
  end

  def update_company
    company = Company.find_by(siret: params[:company_siret])
    return render json: { error: "Target company not found" }, status: :not_found unless company

    if @employee.companies_employee
      @employee.companies_employee.update(company: company)
    else
      CompaniesEmployee.create!(employee: @employee, company: company)
    end

    render json: { message: "Employee reassigned to company #{company.name}" }, status: :ok
  end

  private

  def set_employee_by_hr_id
    @employee = Employee.find_by(employee_hr_id: params[:employee_hr_id])
    render json: { error: "Employee not found" }, status: :not_found unless @employee
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :country)
  end
end
