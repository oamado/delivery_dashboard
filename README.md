# README

This project is a dashboard for shipment records.
It analyzes the delay of every shipment based on the
historical data. It groups by vendor and location
(I use zipcode for simplicity) and calculate the mean and
standard deviation, and based on that, it defines the
delays status.

To seed the database you need to run
```bash
rake db:seed
```

After that you need to initialize the stat data
```bash
rails c
> require './app/services/delay_status_service.rb'
> DelayStatusService.bulk_process
> exit
```

After a shipment is marked as delivered, the backend
recalculate the mean and the standard deviation for the
vendor, zipcode combination.

## Possible improvements

- The dashboard could be better using a SPA
- Create a task to calculate the delay status for the
shipments and store this in db. Is possible to run this every
hour and the visualization will be faster (Not recalculate in
every render)
- Adding to the dashboard limits, order by and pagination

