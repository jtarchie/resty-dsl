require 'resty/dsl/version'
require 'active_record'

module Resty
  Route = Struct.new(:base) do
    def to_s
      "/#{base}"
    end
  end

  Query = Struct.new(:method, :block) do
    def to_s
      %Q{
        postgres_query #{method.upcase} "#{block.call.to_sql.gsub('"','\"')}";
      }
    end
  end

  class Resource
    def initialize(route, &block)
      @route = route
      instance_eval(&block) if block_given?
    end

    def index(&block)
      @index ||= Query.new(:get, block)
    end

    def to_s
      %Q{
            location #{@route.to_s} {
              postgres_pass database;
              rds_json on;

              #{@index}
            }
      }
    end
  end

  class App
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def database(uri)
      @database ||= URI(uri)
    end

    def resource(name, &block)
      @resource ||= Resource.new(Route.new(name), &block)
    end

    def port(port = nil)
      @port ||= port 
    end

    def to_s
      %Q{
        worker_processes 8;

        events {
          worker_connections 1024;
        }

        http {
          upstream database {
            postgres_server #{@database.host} dbname=#{@database.path.gsub('/','')} user=#{@database.user} password=#{@database.password};
          }

          server {
            listen #{port};
            #{@resource}
          }
        }
      }
    end
  end

  module DSL
    def resty(&block)
      App.new(&block)
    end
  end
end
