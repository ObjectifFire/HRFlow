class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :siret
      t.string :name
      t.string :country
      t.integer :revenue_2024

      t.timestamps
    end
  end
end
