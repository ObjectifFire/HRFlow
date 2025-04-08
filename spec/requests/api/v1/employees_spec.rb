require 'rails_helper'

RSpec.describe "API::V1::Employees", type: :request do
  let(:first_user) { FactoryBot.create(:employee, first_name: "Alice", last_name: "Smith", email: "alice@example.com", country: "France") }
  let(:second_user) { FactoryBot.create(:employee, first_name: "Bob", last_name: "Jones", email: "bob@example.com", country: "USA") }

  describe "GET /api/v1/employees" do
    before do
      first_user
      second_user
     end

    it "returns a list of employees with expected fields" do
      get "/api/v1/employees"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      p json
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
end
