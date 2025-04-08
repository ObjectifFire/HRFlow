require 'rails_helper'

RSpec.describe "API::V1::CompaniesEmployees", type: :request do
  describe "GET /api/v1/companies/:company_id/employees" do
    let(:company) { FactoryBot.create(:company, name: "DevCorp") }
    let!(:employee1) { FactoryBot.create(:employee) }
    let!(:employee2) { FactoryBot.create(:employee) }

    before do
      company.employees << [ employee1, employee2 ]
    end

    it "returns all employees assigned to the company with company name included" do
      get "/api/v1/companies/#{company.id}/employees"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(2)

      json.each do |employee|
        expect(employee).to include("first_name", "last_name", "email", "country", "company_name")
        expect(employee["company_name"]).to eq("DevCorp")
      end
    end
  end

  describe "POST /api/v1/companies/:company_id/employees/:employee_id" do
    let!(:company) { FactoryBot.create(:company) }
    let!(:other_company) { FactoryBot.create(:company) }
    let!(:employee) { FactoryBot.create(:employee) }

    context "when employee is not assigned to any company" do
      it "assigns the employee to the company" do
        post "/api/v1/companies/#{company.id}/employees/#{employee.id}"

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Employee assigned")

        expect(company.employees).to include(employee)
      end
    end

    context "when employee is already assigned to another company" do
      before { other_company.employees << employee }

      it "does not assign and returns 422" do
        post "/api/v1/companies/#{company.id}/employees/#{employee.id}"

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Employee is already assigned to a company")

        expect(company.employees).not_to include(employee)
      end
    end
  end


  describe "DELETE /api/v1/companies/:company_id/employees/:employee_id" do
    let!(:company) { FactoryBot.create(:company) }
    let!(:employee) { FactoryBot.create(:employee) }

    context "when employee is assigned to the company" do
      before { company.employees << employee }

      it "removes the employee from the company" do
        expect {
          delete "/api/v1/companies/#{company.id}/employees/#{employee.id}"
        }.to change { company.employees.reload.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when employee is not assigned to the company" do
      it "returns 404 not found" do
        delete "/api/v1/companies/#{company.id}/employees/#{employee.id}"

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Employee not assigned to this company")
      end
    end
  end
end
