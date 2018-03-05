class CreateDeliveryTimingStats < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_timing_stats do |t|
      t.references :vendor, foreign_key: true
      t.integer :zipcode
      t.float :mean
      t.float :std_desv
      t.float :count
    end
  end
end
