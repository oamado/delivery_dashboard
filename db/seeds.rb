# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


50.times do |index|
  Vendor.create!(id: index, name: Faker::Company.name)
end

4000.times do |index|
  shipment_created_date = Faker::Date.between(40.days.ago, 15.days.ago)
  Shipment.create!(order_number: Faker::Number.number(10),
                   vendor_id: Random.new.rand(0..49),
                   tracking_number: Faker::Number.number(10),
                   address:  Faker::Address.street_address + ' ' + Faker::Address.building_number,
                   zipcode: Random.new.rand(10101..10120),
                   delivered_at: shipment_created_date + Random.new.rand(0..20).days,
                   created_at: shipment_created_date)
end


200.times do |index|
  Shipment.create!(order_number: Faker::Number.number(10),
                   vendor_id: Random.new.rand(0..49),
                   tracking_number: Faker::Number.number(10),
                   address:  Faker::Address.street_address + ' ' + Faker::Address.building_number,
                   zipcode: Random.new.rand(10101..10120),
                   created_at: Faker::Date.between(40.days.ago, Date.today))
end