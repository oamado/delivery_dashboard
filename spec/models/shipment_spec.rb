require 'rails_helper'

RSpec.describe Shipment, type: :model do

  after {
    DeliveryTimingStat.delete_all
  }

  after {
    DeliveryTimingStat.delete_all
  }
  it 'return Normal when the value is minor than the mean plus one standard desviation' do
    vendor = Vendor.create(name: 'Amazon')
    shipment = Shipment.create(order_number: '1234',
                    vendor_id: vendor.id,
                    tracking_number: '7890',
                    address: '98765',
                    zipcode: 6798,
                    created_at: DateTime.now - 1.day)
    DeliveryTimingStat.create(vendor_id: vendor.id, zipcode: shipment.zipcode, mean: 72, std_desv: 18, count: 4)

    expect(shipment.delay_status(DeliveryTimingStat.all)).to eq('Normal')

  end

  it 'return Not normal when the value is minor than the mean plus three time standard desviation' do
    vendor = Vendor.create(name: 'Amazon')
    shipment = Shipment.create(order_number: '1234',
                               vendor_id: vendor.id,
                               tracking_number: '7890',
                               address: '98765',
                               zipcode: 6798,
                               created_at: DateTime.now - 4.day)
    DeliveryTimingStat.create(vendor_id: vendor.id, zipcode: shipment.zipcode, mean: 72, std_desv: 18, count: 4)

    expect(shipment.delay_status(DeliveryTimingStat.all)).to eq('Not normal')
  end

  it 'returns Very late when the value is major than the mean plus three time standard desviation' do
    vendor = Vendor.create(name: 'Amazon')
    shipment = Shipment.create(order_number: '1234',
                               vendor_id: vendor.id,
                               tracking_number: '7890',
                               address: '98765',
                               zipcode: 6798,
                               created_at: DateTime.now - 8.day)
    DeliveryTimingStat.create(vendor_id: vendor.id, zipcode: shipment.zipcode, mean: 72, std_desv: 18, count: 4)

    expect(shipment.delay_status(DeliveryTimingStat.all)).to eq('Very late')
  end

  it 'returns Normal when there is not stats for the vendor and location' do
    vendor = Vendor.create(name: 'Amazon')
    shipment = Shipment.create(order_number: '1234',
                               vendor_id: vendor.id,
                               tracking_number: '7890',
                               address: '98765',
                               zipcode: 6798,
                               created_at: DateTime.now - 8.day)

    expect(shipment.delay_status(DeliveryTimingStat.all)).to eq('Normal')
  end
end
