require 'rails_helper'

RSpec.describe "Api::V1::Admin::Companies", type: :request do
  let(:company) { FactoryBot.create(:company) }

  describe "GET /index" do
    before { company }

    it "returns only name, siret, and country" do
      get "/api/v1/admin/companies"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to all(include("name", "siret", "country", "revenue_2024"))
      expect(json.first["revenue_2024"]).to eq(company.revenue_2024)
    end
  end
end
