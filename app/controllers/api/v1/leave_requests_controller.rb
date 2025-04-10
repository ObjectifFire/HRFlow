class Api::V1::LeaveRequestsController < ApplicationController
  before_action :set_employee_by_hr_id, only: [ :create ]
  before_action :set_leave_request, only: [ :cancel ]

  def create
    company = Company.find_by(siret: params[:company_siret])
    return render json: { error: "Company not found" }, status: :not_found unless company

    leave_request = LeaveRequest.new(
      employee: @employee,
      company: company,
      date: Date.parse(params[:date]),
      duration: params[:duration],
      status: "En attente de validation"
    )

    if leave_request.save
      render json: leave_request, status: :created
    else
      render json: { errors: leave_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def pending
    leave_requests = LeaveRequest
      .where(status: "En attente de validation")
      .where("date >= ?", Date.today)

    render json: leave_requests, status: :ok
  end

  def cancel
    if @leave_request.status != "En attente de validation"
      return render json: { error: "Only pending requests can be cancelled" }, status: :unprocessable_entity
    end

    @leave_request.update(status: "Annulé")
    render json: { message: "Leave request cancelled" }, status: :ok
  end

  private

  def set_employee_by_hr_id
    @employee = Employee.find_by(employee_hr_id: params[:employee_hr_id])
    render json: { error: "Employee not found" }, status: :not_found unless @employee
  end

  def set_leave_request
    @leave_request = LeaveRequest.find_by(id: params[:id])
    render json: { error: "Leave request not found" }, status: :not_found unless @leave_request
  end
end
