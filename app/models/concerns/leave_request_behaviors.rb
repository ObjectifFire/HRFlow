module LeaveRequestBehaviors
  extend ActiveSupport::Concern

  included do
    validate :check_start_date
    validate :check_max_duration
    validate :check_max_start_date
    
    after_create :set_status, unless: :skip_status_callback

    attr_accessor :skip_status_callback

    scope :pending_requests, -> {
      where(status: "pending")
      .where("date >= ?", Date.today)
    }
  end

  REQUESTS_STATUS = %w[pending validated cancel].freeze
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

  def check_max_start_date
    return unless date.present? && date > 2.years.from_now
  
    errors.add(:date, "must be within the next 2 years")
  end

  def set_status
    update!(status: "pending")
  end
end
