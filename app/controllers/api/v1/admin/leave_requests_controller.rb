class Api::V1::Admin::LeaveRequestsController < ApplicationController
  before_action :set_employee_by_hr_id, only: [ :create ]
  before_action :set_leave_request, only: [ :update ]

  def create
    company = @employee.company
    return render json: { error: "Company not found" }, status: :not_found unless company

    leave_request = LeaveRequest.new(
      employee: @employee,
      company: company,
      date: Date.parse(params[:date]),
      duration: params[:duration],
      status: params[:status]
    )

    leave_request.skip_status_callback = true

    if leave_request.save
      render json: leave_request, status: :created
    else
      render json: { errors: leave_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    status = params[:status] if @leave_request.allowed_status?(params[:status])

    if status
      @leave_request.update!(status: status)

      render json: { message: "Leave request status #{status}" }, status: :ok
    else
      render json: { message: " #{params[:status]} is not an avaiable status" }, status: :unprocessable_entity
    end
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
