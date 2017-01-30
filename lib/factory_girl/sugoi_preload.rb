require "factory_girl/sugoi_preload/version"
require "factory_girl/ext"

module FactoryGirl
  module SugoiPreload
    class << self
      attr_accessor :blocks, :records, :model_id_table
    end
  end
end

if defined?(RSpec) # for console
  RSpec.configure do |config|
    config.before(:suite) do
      # fixtuireを使っていないならここでok
      # FactoryGirl::SugoiPreload.clean
      # FactoryGirl::SugoiPreload.run
    end

    config.before(:each) do
      # テスト実行する毎にメモリが増えていかないよう必要分だけをメモリにのせる
      FactoryGirl::SugoiPreload.reload_factories
    end
  end
end


# fixtuiresをロード後にこれをロードする
module FactoryGirl
  module SugoiPreload
    module Runner
      def before_setup
        ActiveRecord::Base.connection.commit_transaction
        FactoryGirl::SugoiPreload.clean
        FactoryGirl::SugoiPreload.run
        ActiveRecord::Base.connection.begin_transaction
        super
      end
    end
  end
end
ActiveRecord::TestFixtures.include(FactoryGirl::SugoiPreload::Runner)
