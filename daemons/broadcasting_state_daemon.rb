#!/usr/bin/env ruby

# Usage:
#   $> RAILS_ENV=<rails_env> <app_path>/daemons/broadcasting_state_daemon.rb
#
# Description:
#   It's a daemon for runit, updating broacdasting status.

require 'bundler/setup'

APP_DIR = File.expand_path('../../', __FILE__)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', APP_DIR)
require File.expand_path("config/environment", APP_DIR)

WORK_PERIOD = configus.broadcasting.request_period

loop do
  sleep WORK_PERIOD

  Rails.logger.info 'updating broadcasting status'

  BroadcastingStatusUpdater.update_by(:camera_json)
end
