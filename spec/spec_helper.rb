$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'factory_girl/sugoi_cache'

ENV["RAILS_ENV"] = "test"
ENV["BUNDLE_GEMFILE"] = File.dirname(__FILE__) + "/../Gemfile"

require "bundler/setup"
require "rails/all"

module RSpec
  class Application < ::Rails::Application
    config.root = File.dirname(__FILE__) + "/support/app"
    config.active_support.deprecation = :log
    config.eager_load = false
  end
end
RSpec::Application.initialize!
ActiveRecord::Migration.verbose = true
load File.dirname(__FILE__) + "/support/app/db/schema.rb"
