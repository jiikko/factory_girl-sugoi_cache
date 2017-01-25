module FactoryGirl
  module SugoiPreload
    module Helper
      def factory(name, &block)
        FactoryGirl::SugoiPreload.cache_records ||= {}
        # TODO lazy
        FactoryGirl::SugoiPreload.cache_records[name] = yield
      end
    end

    def self.clean
      ActiveRecord::Base.connection.disable_referential_integrity do
        ActiveRecord::Base.descendants.each(&:delete_all)
      end
    end

    def self.run
      factory_girl_object = Object.new.extend(
        FactoryGirl::Syntax::Methods,
        FactoryGirl::SugoiPreload::Helper,
      )

      ActiveRecord::Base.connection.transaction :requires_new => true do
        FactoryGirl::SugoiPreload.cache_blocks.each do |block|
          factory_girl_object.instance_eval(&block)
        end
      end
    end

    def self.reload_factories
    end
  end

  module Syntax
    module Methods
      def find_cache(name)
        FactoryGirl::SugoiPreload.cache_records[name]
      end
    end
  end

  module Syntax
    module Default
      class DSL
        def cache(&block)
          FactoryGirl::SugoiPreload.cache_blocks ||= []
          FactoryGirl::SugoiPreload.cache_blocks << block
        end
      end
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
