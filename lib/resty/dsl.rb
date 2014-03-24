require 'resty/dsl/version'
require 'active_record'
require 'resty/dsl/app'

module Resty
  module DSL
    def resty(&block)
      App.new(&block)
    end
  end
end
