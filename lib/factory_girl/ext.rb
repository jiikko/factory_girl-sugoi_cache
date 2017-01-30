module FactoryGirl
  module SugoiCache
    module Helper
      def factory(name, &block)
        FactoryGirl::SugoiCache.model_id_table ||= {}
        record = yield
        FactoryGirl::SugoiCache.model_id_table[name] = { model: record.class, id: record.id }
      end
    end

    # 全モデルでdelete_allしない, cleanするレコード の条件は
    # * fixtuiresが取り込んだレコード以外
    # を削除する
    def self.clean
      ActiveRecord::FixtureSet.cached_fixtures(ActiveRecord::Base.connection).each do |fixture_set|
        # FactoryGirl::SugoiCache.model_id_table にのっているテーブルはskipする
        ActiveRecord::Base.connection.disable_referential_integrity do
          fixture_set.model_class.
            where.not(
              id: fixture_set.fixtures.map { |key, fixture| fixture['id'] }
          ).delete_all
        end
      end
    end

    def self.run
      factory_girl_object = Object.new.extend(
        FactoryGirl::Syntax::Methods,
        FactoryGirl::SugoiCache::Helper,
      )
      ActiveRecord::Base.connection.transaction(requires_new: true) do
        FactoryGirl::SugoiCache.blocks.each do |block|
          factory_girl_object.instance_eval(&block)
        end
      end
    end

    def self.reload_factories
      FactoryGirl::SugoiCache.records = nil
      FactoryGirl::SugoiCache.records ||= {}
    end
  end

  module Syntax
    module Methods
      def find_cache(name)
        record = FactoryGirl::SugoiCache.records[name]
        unless record
          hash = FactoryGirl::SugoiCache.model_id_table[name]
          record = hash[:model].find(hash[:id])
          FactoryGirl::SugoiCache.records[name] = record
        end
        return record
      end
    end
  end

  module Syntax
    module Default
      class DSL
        def cache(&block)
          FactoryGirl::SugoiCache.blocks ||= []
          FactoryGirl::SugoiCache.blocks << block
        end
      end
    end
  end
end
