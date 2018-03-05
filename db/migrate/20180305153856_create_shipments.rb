class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.string :order_number
      t.references :vendor, foreign_key: true
      t.string :tracking_number
      t.string :address
      t.integer :zipcode
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
