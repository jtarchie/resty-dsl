module Resty
  Route = Struct.new(:base) do
    def to_s
      "/#{base}"
    end
  end
end
