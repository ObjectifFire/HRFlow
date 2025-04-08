require 'rails_helper'

RSpec.describe "API::V1::Employees", type: :request do
  describe "GET /api/v1/employees" do
    before do
      create(:employee, first_name: "Alice", last_name: "Smith", email: "alice@example.com", country: "France")
      create(:employee, first_name: "Bob", last_name: "Jones", email: "bob@example.com", country: "USA")
    end

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
end
