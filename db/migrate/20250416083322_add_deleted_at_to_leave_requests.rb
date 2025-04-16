class AddDeletedAtToLeaveRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :leave_requests, :deleted_at, :datetime
    add_index :leave_requests, :deleted_at
  end
end
