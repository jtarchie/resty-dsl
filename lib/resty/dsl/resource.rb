require 'resty/dsl/query'

module Resty
  class Resource
    def initialize(route, &block)
      @route = route
      instance_eval(&block) if block_given?
    end

    def index(&block)
      @index ||= Query::Index.new(block)
    end

    def show(&block)
      @show ||= Query::Show.new(block)
    end

    def path
      @route.to_s
    end

    def to_s
      %Q{
            location @err404 {
              default_type application/json;
              echo '{"status":404}';
            }
            error_page 404 @err404;

            location #{path} {
              postgres_pass database;
              rds_json on;

              #{@index}
            }

            location ~ #{path}/(?<id>\\d+) {
              postgres_pass database;
              rds_json on;

              postgres_escape $escaped_id $id;
              #{@show}
            }
      }
    end
  end
end
