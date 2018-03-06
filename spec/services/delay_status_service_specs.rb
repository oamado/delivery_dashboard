require 'rails_helper'

RSpec.describe DelayStatusService, type: :service do
  describe 'bulk_process' do

    before(:all) {
      vendor = Vendor.create(name: 'Amazon')
      shipment = Shipment.create(order_number: '1234',
                                 vendor_id: vendor.id,
                                 tracking_number: '7890',
                                 address: '98765',
                                 zipcode: 456789,
                                 created_at: DateTime.now - 10.day,
                                 delivered_at: DateTime.now - 5.day)

      shipment_1 = Shipment.create(order_number: '1234',
                                   vendor_id: vendor.id,
                                   tracking_number: '7890',
                                   address: '98765',
                                   zipcode: 456789,
                                   created_at: DateTime.now - 10.day,
                                   delivered_at: DateTime.now - 8.day)

      shipment_2 = Shipment.create(order_number: '1234',
                                   vendor_id: vendor.id,
                                   tracking_number: '7890',
                                   address: '98765',
                                   zipcode: 456789,
                                   created_at: DateTime.now - 10.day,
                                   delivered_at: DateTime.now - 2.day)

      DelayStatusService.bulk_process
    }

    after(:all){
      Shipment.delete_all
      DeliveryTimingStat.delete_all
    }


    it 'calculates the correct mean' do
      expect(DeliveryTimingStat.first.mean).to be_within(0.1).of(120.0)
    end

    it 'calculates the correct standard deviation' do
      expect(DeliveryTimingStat.first.std_desv).to be_within(0.1).of(58.78)
    end

    it 'calculates the number of records' do
      expect(DeliveryTimingStat.first.count).to eq(3)
    end
  end

  describe 'process' do

    before(:all){
      vendor = Vendor.create(name: 'Amazon')
      shipment = Shipment.create(order_number: '1234',
                                 vendor_id: vendor.id,
                                 tracking_number: '7890',
                                 address: '98765',
                                 zipcode: 2609367,
                                 created_at: DateTime.now - 10.day,
                                 delivered_at: DateTime.now - 5.day)


      DeliveryTimingStat.create(vendor_id: vendor.id, zipcode: shipment.zipcode, mean: 48, std_desv: 24, count: 5)

      DelayStatusService.process(shipment)

    }

    after(:all){
      Shipment.delete_all
      DeliveryTimingStat.delete_all
    }


    it 'calculates the correct mean' do
      expect(DeliveryTimingStat.first.mean).to be_within(0.1).of(60.0)
    end

    it 'calculates the correct standard deviation' do
      expect(DeliveryTimingStat.first.std_desv).to be_within(0.1).of(32.86)
    end

    it 'calculates the number of records' do
      expect(DeliveryTimingStat.first.count).to eq(6)
    end
  end

end