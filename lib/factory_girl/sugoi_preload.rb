require "factory_girl/sugoi_preload/version"
require "factory_girl/ext"

module FactoryGirl
  module SugoiPreload
    class << self
      attr_accessor \
        :blocks, \
        :records, \
        :model_id_table
    end
  end
end

if defined?(RSpec) # for console
  RSpec.configure do |config|
    config.before(:suite) do
      FactoryGirl::SugoiPreload.clean
      FactoryGirl::SugoiPreload.run
    end

    config.before(:each) do
      FactoryGirl::SugoiPreload.reload_factories
    end
  end
end
