require 'rails_helper'

RSpec.describe "API::V1::Employees", type: :request do
  let!(:first_user) { FactoryBot.create(:employee, first_name: "Alice", last_name: "Smith", email: "alice@example.com", country: "France") }
  let!(:second_user) { FactoryBot.create(:employee, first_name: "Bob", last_name: "Jones", email: "bob@example.com", country: "USA") }

  describe "GET /api/v1/employees" do
    it "returns a list of employees with expected fields" do
      get "/api/v1/employees"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(2)

      json.each do |employee|
        expect(employee.keys).to contain_exactly("first_name", "last_name", "email", "country")
      end
    end
  end

  describe "POST /api/v1/employees" do
    let(:valid_params) do
      {
        employee: {
          first_name: "John",
          last_name: "Machartur",
          email: "john@machartur.com",
          country: "France"
        }
      }
    end

    let(:invalid_params_missing_email) do
      {
        employee: {
          first_name: "Maurice",
          last_name: "Banotti",
          country: "France"
        }
      }
    end

    let(:invalid_params_duplicate_email) do
      {
        employee: {
          first_name: "Jean",
          last_name: "Bernard",
          email: "john@machartur.com",
          country: "France"
        }
      }
    end

    it "creates an employee with valid params" do
      expect {
        post "/api/v1/employees", params: valid_params
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("john@machartur.com")
    end

    it "returns 422 when email is missing" do
      post "/api/v1/employees", params: invalid_params_missing_email

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Email can't be blank")
    end

    it "returns 422 when email is already taken" do
      Employee.create!(valid_params[:employee])

      post "/api/v1/employees", params: invalid_params_duplicate_email

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Email has already been taken")
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    let!(:employee) { FactoryBot.create(:employee) }

    it "deletes the employee successfully" do
      expect {
        delete "/api/v1/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 if employee does not exist" do
      delete "/api/v1/employees/999999"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Employee not found")
    end

    it "returns 422 if deletion fails" do
      allow_any_instance_of(Employee).to receive(:destroy).and_return(false)

      delete "/api/v1/employees/#{employee.id}"

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Failed to delete employee")
    end
  end

  describe "PATCH /api/v1/employees/:id/company" do
    let!(:employee) { FactoryBot.create(:employee) }
    let!(:old_company) { FactoryBot.create(:company) }
    let!(:new_company) { FactoryBot.create(:company) }
  
    before do
      old_company.employees << employee
    end
  
    context "when both employee and new company exist" do
      it "reassigns the employee to the new company" do
        patch "/api/v1/employees/#{employee.id}/company", params: { company_id: new_company.id }
  
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["message"]).to include(new_company.name)
  
        expect(employee.reload.companies).to contain_exactly(new_company)
      end
    end
  
    context "when employee does not exist" do
      it "returns 404" do
        patch "/api/v1/employees/99999/company", params: { company_id: new_company.id }
  
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Employee not found")
      end
    end
  
    context "when new company does not exist" do
      it "returns 404" do
        patch "/api/v1/employees/#{employee.id}/company", params: { company_id: 99999 }
  
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Target company not found")
      end
    end
  end  
end
