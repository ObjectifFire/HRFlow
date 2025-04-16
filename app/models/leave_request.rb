class LeaveRequest < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  validates :duration, :date, presence: true

  include LeaveRequestBehaviors
end
