require 'rails_helper'

RSpec.describe "API::V1::Admin::Employees", type: :request do
  describe "GET /api/v1/admin/employees" do
    let!(:employee1) { FactoryBot.create(:employee, email: "alice@admin.com") }
    let!(:employee2) { FactoryBot.create(:employee, email: "bob@admin.com") }

    it "returns a list of employees" do
      get "/api/v1/admin/employees"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
      expect(json.map { |e| e["email"] }).to contain_exactly("alice@admin.com", "bob@admin.com")
    end
  end

  describe "POST /api/v1/admin/employees" do
    let(:minimal_valid_params) do
      {
        employee: {
          email: "mytest@mail.com"
        }
      }
    end

    let(:invalid_params_missing_email) do
      {
        employee: {
          first_name: "No",
          last_name: "Email"
        }
      }
    end

    it "creates an employee with only email" do
      expect {
        post "/api/v1/admin/employees", params: minimal_valid_params
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("mytest@mail.com")
    end

    it "returns 422 when email is missing" do
      post "/api/v1/admin/employees", params: invalid_params_missing_email

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Email can't be blank")
    end
  end

  describe "DELETE /api/v1/admin/employees/:employee_hr_id" do
    let!(:employee) { FactoryBot.create(:employee) }

    it "deletes the employee successfully" do
      expect {
        delete "/api/v1/admin/employees/#{employee.employee_hr_id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 if employee is not found" do
      delete "/api/v1/admin/employees/FAKE-ID"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Employee not found")
    end

    it "returns 422 if deletion fails" do
      allow_any_instance_of(Employee).to receive(:destroy).and_return(false)

      delete "/api/v1/admin/employees/#{employee.employee_hr_id}"

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Failed to delete employee")
    end
  end
end
