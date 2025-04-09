class AddEmployeeHrIdToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_column :employees, :employee_hr_id, :string
    add_index :employees, :employee_hr_id, unique: true
  end
end
