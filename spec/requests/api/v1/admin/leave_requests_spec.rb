require 'rails_helper'

RSpec.describe "API::V1::Admin::LeaveRequests", type: :request do
  let!(:employee) { FactoryBot.create(:employee) }
  let!(:company) { FactoryBot.create(:company) }

  describe "POST /api/v1/admin/leave_requests" do
    let(:valid_params) do
      {
        employee_hr_id: employee.employee_hr_id,
        company_siret: company.siret,
        status: "validated",
        date: (Date.today + 1).to_s,
        duration: "1 day"
      }
    end

    it "creates a leave request successfully" do
      expect {
        post "/api/v1/admin/leave_requests", params: valid_params
      }.to change(LeaveRequest, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("validated")
    end

    it "returns 404 if company not found" do
      invalid_params = valid_params.merge(company_siret: "FAKE")
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
    let!(:leave_request) { FactoryBot.create(:leave_request, employee: employee, company: company) }

    it "cancels a leave request" do
      patch "/api/v1/admin/leave_requests/#{leave_request.id}", params: { employee_hr_id: employee.employee_hr_id }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Leave request cancelled")
      expect(leave_request.reload.status).to eq("canceled")
    end

    it "returns 404 if leave request not found" do
      patch "/api/v1/admin/leave_requests/999999", params: { employee_hr_id: employee.employee_hr_id }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Leave request not found")
    end

    it "returns 200 if request is not pending" do
      leave_request.update(status: "Validé")

      patch "/api/v1/admin/leave_requests/#{leave_request.id}", params: { employee_hr_id: employee.employee_hr_id }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Only pending requests can be cancelled")
    end
  end
end
