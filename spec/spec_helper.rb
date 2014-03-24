require_relative '../lib/resty/dsl'
require 'sqlite3'
require 'with_model'
require 'pry'

ENV['DATABASE_URL'] ||= 'postgresql://dsl:dsl@127.0.0.1/resty_dsl_test'
ENV['PORT'] ||= 9979.to_s

require_relative 'support/api_dsl'
require_relative 'support/models'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.extend(WithModel)
  config.include(ApiDSL)
  config.include(Resty::DSL)
  config.before { User.delete_all }
end
