module AfterbanksPSD2
  class Collection < Array
    def initialize(response, item_klass)
      response.each do |item|
        self << item_klass.new(item)
      end
    end
  end
end
