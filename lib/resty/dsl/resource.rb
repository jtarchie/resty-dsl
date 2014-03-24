module Resty
  class Resource
    def initialize(route, &block)
      @route = route
      instance_eval(&block) if block_given?
    end

    def index(&block)
      @index ||= Query.new(:get, block)
    end

    def path
      @route.to_s
    end

    def to_s
      %Q{
            location #{path} {
              postgres_pass database;
              rds_json on;

              #{@index}
            }
      }
    end
  end
end
