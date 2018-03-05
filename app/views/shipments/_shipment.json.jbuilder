json.extract! shipment, :id, :order_number, :vendor_id, :tracking_number, :address, :zipcode, :delivered_at, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
