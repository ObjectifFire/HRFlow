namespace :leave_requests do
  desc "Cancel leave requests still pending but with end date in the past"
  task cancel_expired: :environment do
    expired = LeaveRequest.where(status: "pending").select do |lr|
      lr.calculate_end_date < Time.current
    end

    expired.each do |leave|
      leave.update!(status: "cancel")
      puts "LeaveRequest ##{leave.id} updated to cancel"
    end

    puts "#{expired.size} leave requests updated."
  end
end
