class Api::V1::CompaniesEmployeesController < ApplicationController
  before_action :set_company
  before_action :set_employee, only: [:create, :destroy]

  def index
    employees = @company.employees.ordered_by_name
  
    render json: employees.map { |employee|
      employee.as_json(only: [:first_name, :last_name, :email, :country]).merge(
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

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: { error: 'Company not found' }, status: :not_found unless @company
  end

  def set_employee
    @employee = Employee.find_by(id: params[:employee_id])
    render json: { error: 'Employee not found' }, status: :not_found unless @employee
  end
end
