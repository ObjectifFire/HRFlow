class CreateAbsences < ActiveRecord::Migration[8.0]
  def change
    create_table :absences do |t|
      t.references :company, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.string :duration
      t.string :status

      t.timestamps
    end
  end
end
