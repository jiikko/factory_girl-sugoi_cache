require "factory_girl/sugoi_cache/version"
require "factory_girl/ext"

module FactoryGirl
  module SugoiCache
    class << self
      attr_accessor :blocks, :records, :model_id_table
    end
  end
end

if defined?(RSpec) # for console
  RSpec.configure do |config|
    config.before(:suite) do
      # fixtuireを使っていないならここでok
      # FactoryGirl::SugoiCache.clean
      # FactoryGirl::SugoiCache.run
    end

    config.before(:each) do
      # テスト実行する毎にメモリが増えていかないよう必要分だけをメモリにのせる
      FactoryGirl::SugoiCache.reload_factories
    end
  end
end


# fixtuiresをロード後にこれをロードする
module FactoryGirl
  module SugoiCache
    module Runner
      def before_setup
        if self.use_transactional_fixtures
          ActiveRecord::Base.connection.commit_transaction
          FactoryGirl::SugoiCache.clean
          FactoryGirl::SugoiCache.run
          ActiveRecord::Base.connection.begin_transaction
        end
        super
      end
    end
  end
end
ActiveRecord::TestFixtures.include(FactoryGirl::SugoiCache::Runner)
