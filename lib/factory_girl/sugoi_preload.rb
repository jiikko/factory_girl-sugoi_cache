require "factory_girl/sugoi_preload/version"
require "factory_girl/ext"

module FactoryGirl
  module SugoiPreload
    class << self
      attr_accessor \
        :cache_blocks, \
        :cache_records, \
        :cache_ids,
    end
  end
end
