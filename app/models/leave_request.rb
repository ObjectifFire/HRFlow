class LeaveRequest < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  validates :duration, :date, presence: :true
  validate :date_range_check
 # validate :can_be_deleted?, on: :delete

  before_update :check_status
  before_create :check_max_duration
  after_create :set_status

  scope :pending_requests, -> {
    where(status: "pending")
    where("date >= ?", Date.today)
  }

  LEAVE_REQUEST_MAX_DURATION_IN_DAYS = [45].freeze
  
  def calculate_end_date
    date + duration[/\d+/].to_i.days
  end



  private

  def check_max_duration
   return if duration[/\d+/].to_i < LEAVE_REQUEST_MAX_DURATION_IN_DAYS

   errors.add(:duration, "Must be #{LEAVE_REQUEST_MAX_DURATION_IN_DAYS} max.")
  end
  def date_range_check
     return unless date < Time.current

     errors.add(:date, "Must be > to today date")
  end

  def check_status
    
  end

  def set_status
    update!(status: "pending")
  end
end
