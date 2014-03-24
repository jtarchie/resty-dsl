require 'resty/dsl/version'
require 'active_record'
require 'resty/dsl/route'
require 'resty/dsl/query'
require 'resty/dsl/resource'
require 'resty/dsl/app'

module Resty
  module DSL
    def resty(&block)
      App.new(&block)
    end
  end
end
