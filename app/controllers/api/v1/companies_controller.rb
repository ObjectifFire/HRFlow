class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.public_info
    render json: companies.as_json, status: :ok
  end
end
