module Resty
  module Query
    Base = Struct.new(:block) do
      def to_s
        %Q{
          postgres_query #{method.upcase} "#{scope.to_sql.gsub('"','\"')}";
        }
      end

      private

      def scope
        block.call
      end
    end

    class Index < Base
      def method
        :get
      end
    end

    class Show < Base
      def method
        :get
      end

      private

      def scope
        scope = block.call
        scope.where(scope.arel_table[scope.primary_key].eq(Arel::Nodes::BindParam.new '$escaped_id'))
      end
    end
  end
end
