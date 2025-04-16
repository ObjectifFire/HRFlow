class LeaveRequest < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :employee

  validates :duration, :date, presence: true

  include LeaveRequestBehaviors
end
