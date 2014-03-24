require 'resty/dsl/resource'
require 'resty/dsl/route'

module Resty
  class App
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def database(uri=nil)
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

end
