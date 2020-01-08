require './config/environment'
require 'rack-timeout'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# Add Sinatra Middleware to intercept PATCH and DELETE requests
use Rack::MethodOverride

# Mount controllers
use ReactionsController
use MedicationsController
use UsersController
use SessionsController

# Add Rack timeout Middleware
use Rack::Timeout, service_timeout: 15

run ApplicationController