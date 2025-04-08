class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :country

      t.timestamps
    end
  end
end
