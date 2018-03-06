class DelayStatusService

  def self.bulk_process
    shipments = Shipment.where.not(delivered_at: nil).preload(:vendor)
    shipments = shipments.group_by {|s| [ s.vendor_id, s.zipcode ]}

    shipments.each do |s|
      hours = s[1].map{ |x| (x.delivered_at - x.created_at) / 3600 }
      mean = mean(hours)
      DeliveryTimingStat.create(vendor: s[1].first.vendor, zipcode: s[0][1], mean: mean, std_desv: std_desv(hours, mean),
                                count: s[1].length)

    end
  end

  def self.process(shipment)
    hours = (shipment.delivered_at - shipment.created_at) / 3600
    stats = DeliveryTimingStat.find_by(vendor_id: shipment.vendor_id, zipcode: shipment.zipcode)
    if stats
      stats.mean = incremental_mean(stats.mean, stats.count, hours)
      stats.std_desv = incremental_std_desviation(stats.std_desv, stats.mean , stats.count, hours )
      stats.count += 1
      stats.save
    else
      DeliveryTimingStat.create(vendor_id: shipment.vendor_id, zipcode: shipment.zipcode,
                                mean: hours, std_desv: 0, count: 1)
    end
  end

  def self.mean(values)
    sum = values.sum
    sum.to_f / values.length.to_f
  end

  def self.std_desv(values, mean)
    sum = (values.map {|v| (v-mean)**2}).sum
    Math.sqrt(sum.to_f / values.length.to_f)
  end

  def self.incremental_mean(p_mean, count, value)
    (count * p_mean + value)/(count + 1)
  end

  def self.incremental_std_desviation(p_std_desv, mean, count, value)
    p_variance = p_std_desv * p_std_desv
    Math.sqrt((p_variance * count + (value - mean)**2)/(count + 1))
  end
end