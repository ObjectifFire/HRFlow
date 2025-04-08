class Employee < ApplicationRecord
  has_many :companies_employees
  has_many :companies, through: :companies_employees
  has_many :leave_requests
end
