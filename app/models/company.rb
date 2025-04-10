class Company < ApplicationRecord
  has_many :companies_employees, dependent: :destroy
  has_many :employees, through: :companies_employees
  has_many :leave_requests

  scope :public_info, -> { select(:name, :siret, :country) }
  scope :admin_info, -> { select(:name, :siret, :country, :revenue_2024) }

end
