class Shipment < ApplicationRecord
  belongs_to :vendor

  def delay_status(stats)
    stats = stats.find{ |x| x.vendor_id = self.vendor_id, x.zipcode = self.zipcode }
    if stats
      hours = (Time.now - self.created_at).to_f / 3600.to_f
      if hours < stats.mean + stats.std_desv
        'Normal'
      elsif hours < stats.mean + stats.std_desv * 3
        'Not normal'
      else
        'Very late'
      end
    else
      'Normal'
    end
  end
end
