class LeaveRequest < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  validates :duration, :date, presence: :true
  validate :date_range_check

  after_create :set_status

  private
  def date_range_check
    # return unless date < Date.today

    # errors.add(:date, "Must be > to today date")
  end

  def set_status
    update!(status: "pending")
  end
end
