class CreateRemedies < ActiveRecord::Migration
  def change
    create_table :remedies do |t|
      t.string :name
      t.string :lab_name
      t.string :lab_cod
      t.string :lab_price
      t.string :max_price
      t.string :code
      t.string :generic
      t.string :active_principle
      t.integer :presentation_id

      t.timestamps null: false
    end
  end
end
