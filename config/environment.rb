# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
address: 'smtp.gmail.com',
port: 587,
domain: 'localhost:3000',
user_name: 'zenithmanuel@gmail.com',
password: 'hwdjhxyubemsbfjc',
authentication: 'plain',
enable_starttls_auto: true,
open_timeout: 5,
read_timeout: 5 }
