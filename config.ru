# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'unicorn/worker_killer'

run Rails.application