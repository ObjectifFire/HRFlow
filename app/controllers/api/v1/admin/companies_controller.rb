class Api::V1::Admin::CompaniesController < ApplicationController
  def index
    companies = Company.admin_info
    render json: companies.as_json(only: [ :name, :siret, :country, :revenue_2024 ]), status: :ok
  end
end
