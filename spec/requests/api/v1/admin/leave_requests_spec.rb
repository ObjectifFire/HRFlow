require 'rails_helper'

RSpec.describe "API::V1::Admin::LeaveRequests", type: :request do
  let!(:company) { FactoryBot.create(:company, :with_employees) }
  let!(:employee) { FactoryBot.create(:employee) }

  describe "POST /api/v1/admin/leave_requests" do
    let(:valid_params) do
      {
        employee_hr_id: company.employees.first.employee_hr_id,
        status: "validated",
        date: (Date.today + 3).to_s,
        duration: "1 day"
      }
    end

    it "creates a leave request successfully" do
      post "/api/v1/admin/leave_requests", params: valid_params
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("validated")
    end

    it "returns 404 if company not found" do
      invalid_params = valid_params.merge(employee_hr_id: employee.employee_hr_id)
      post "/api/v1/admin/leave_requests", params: invalid_params

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Company not found")
    end

    it "returns 404 if employee not found" do
      invalid_params = valid_params.merge(employee_hr_id: "HR99999")
      post "/api/v1/admin/leave_requests", params: invalid_params

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Employee not found")
    end
  end

  describe "PATCH /api/v1/admin/leave_requests/:id" do
    let!(:leave_request) { FactoryBot.create(:leave_request, date: (Date.today + 3).to_s, company: company) }

    it "cancel a leave request" do
      patch "/api/v1/admin/leave_requests/#{leave_request.id}", params: { status: "cancel"}

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Leave request status cancel")
      expect(leave_request.reload.status).to eq("cancel")
    end

    it "validates a leave request" do
      patch "/api/v1/admin/leave_requests/#{leave_request.id}", params: { status: "validated"}

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Leave request status validated")
      expect(leave_request.reload.status).to eq("validated")
    end

    it "returns 404 if leave request not found" do
      patch "/api/v1/admin/leave_requests/999999", params: { employee_hr_id: employee.employee_hr_id }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Leave request not found")
    end
  end
end
