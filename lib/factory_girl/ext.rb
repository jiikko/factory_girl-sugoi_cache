module FactoryGirl
  module SugoiPreload
    module Helper
      def factory(name, &block)
        FactoryGirl::SugoiPreload.model_id_table ||= {}
        record = yield
        FactoryGirl::SugoiPreload.model_id_table[name] = { model: record.class, id: record.id }
      end
    end

    def self.clean
      # TODO 全モデルでdelete_allしない, cleanするレコード の条件は
      # fixtuiresが取り込んだレコード以外
      #   かつ
      # self#runで生成したレコード以外
      # を削除する
      FactoryGirl::SugoiPreload.model_id_table.values
      ActiveRecord::Base.connection.disable_referential_integrity do
        ActiveRecord::Base.descendants.each(&:delete_all)
      end
    end

    def self.run
      factory_girl_object = Object.new.extend(
        FactoryGirl::Syntax::Methods,
        FactoryGirl::SugoiPreload::Helper,
      )
      ActiveRecord::Base.connection.transaction(requires_new: true) do
        FactoryGirl::SugoiPreload.blocks.each do |block|
          factory_girl_object.instance_eval(&block)
        end
      end
    end

    def self.clean_and_run
      # TODO
    end

    def self.reload_factories
      FactoryGirl::SugoiPreload.records = nil
      FactoryGirl::SugoiPreload.records ||= {}
    end
  end

  module Syntax
    module Methods
      def find_cache(name)
        record = FactoryGirl::SugoiPreload.records[name]
        unless record
          hash = FactoryGirl::SugoiPreload.model_id_table[name]
          FactoryGirl::SugoiPreload.records[name] = hash[:model].find(hash[:id])
        end
        return record
      end
    end
  end

  module Syntax
    module Default
      class DSL
        def cache(&block)
          FactoryGirl::SugoiPreload.blocks ||= []
          FactoryGirl::SugoiPreload.blocks << block
        end
      end
    end
  end
end
