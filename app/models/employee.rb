class Employee < ApplicationRecord
  has_many :companies_employees, dependent: :destroy
  has_many :companies, through: :companies_employees
  has_many :leave_requests

  validates :first_name, :last_name, :email, :employee_hr_id, presence: true
  validates :email, :employee_hr_id, uniqueness: true

  scope :ordered_by_name, -> { order(:last_name, :first_name) }
  scope :with_companies, -> { includes(:companies) }
end
