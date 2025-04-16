class LeaveRequest < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  validates :duration, :date, presence: :true
  validate :check_start_date

  before_update :check_status
  before_create :check_max_duration
  after_create :set_status, unless: :skip_status_callback

  scope :pending_requests, -> {
    where(status: "pending")
    where("date >= ?", Date.today)
  }

  attr_accessor :skip_status_callback

  REQUESTS_STATUS = ['pending', 'validated', 'cancel'].freeze

  LEAVE_REQUEST_MAX_DURATION_IN_DAYS = [ 45 ].freeze

  def calculate_end_date
    date + duration[/\d+/].to_i.days
  end

  def cancelable?
    status == "pending" && date > Time.current
  end

  def allowed_status?(update_status)
    update_status.in?(REQUESTS_STATUS)
  end

  private

  def check_max_duration
   return if duration[/\d+/].to_i < LEAVE_REQUEST_MAX_DURATION_IN_DAYS[0]

   errors.add(:duration, "Must be #{LEAVE_REQUEST_MAX_DURATION_IN_DAYS} max.")
  end

  def check_start_date
     return unless date < Time.current

     errors.add(:date, "has to start after today")
  end

  def check_status
  end

  def set_status
    update!(status: "pending")
  end
end
