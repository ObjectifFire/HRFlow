class Employee < ApplicationRecord
  has_one :companies_employee, dependent: :destroy
  has_one :company, through: :companies_employee
  has_many :leave_requests, dependent: :destroy

  before_validation :set_hr_id, on: :create

  validates :first_name, :last_name, :email, :employee_hr_id, presence: true
  validates :email, :employee_hr_id, uniqueness: true

  scope :ordered_by_name, -> { order(:last_name, :first_name) }

  private

  def set_hr_id
    return if employee_hr_id.present?

    begin
      self.employee_hr_id = "HR#{SecureRandom.hex(3).upcase}"
    end while self.class.exists?(employee_hr_id: employee_hr_id)
  end
end
