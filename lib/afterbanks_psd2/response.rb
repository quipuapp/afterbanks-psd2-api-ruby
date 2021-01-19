module AfterbanksPSD2
  class Response
    attr_accessor :result

    def initialize(result:)
      @result = result
    end
  end
end
