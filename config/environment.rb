# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
WatchRepair::Application.initialize!

WatchRepair::Application.configure do
  config.title = 'Marty Kale Watch Repair'
  config.invoice_start_number = 60000
  config.addressee = 'Marty Kale'
  config.street = '63 Averill Road'
  config.city_state_zip = 'Brookline, NH 03033'
  config.phone = 'Phone/Fax: 603.673.9158'
  config.email = 'Email: martykale@gmail.com'
  config.terms = 'Net Amount Due In 30 Days'
end