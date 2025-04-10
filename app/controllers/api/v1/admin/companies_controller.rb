class Api::V1::Admin::CompaniesController < ApplicationController
  def index
    companies = Company.admin_info
    render json: companies.as_json(only: [ :name, :siret, :country ]), status: :ok
  end
end
