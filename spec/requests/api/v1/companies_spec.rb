require 'rails_helper'

RSpec.describe "Api::V1::Companies", type: :request do
  let(:company) { FactoryBot.build(:company) }

  describe "GET /index" do
    before { company }

    it "returns only name, siret, and country" do
      get "/api/v1/companies"
      expect(response).to have_http_status(:ok)
    
      json = JSON.parse(response.body)
      expect(json).to all(include("name", "siret", "country"))
      expect(json.include?("revenue_2024")).to be_falsy
    end
  end
end
