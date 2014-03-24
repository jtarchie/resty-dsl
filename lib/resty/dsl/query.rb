module Resty
  Query = Struct.new(:method, :block) do
    def to_s
      %Q{
        postgres_query #{method.upcase} "#{block.call.to_sql.gsub('"','\"')}";
      }
    end
  end
end
