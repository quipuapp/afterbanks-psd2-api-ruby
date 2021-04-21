module AfterbanksPSD2
  class Response
    attr_accessor :result, :body, :debug_id

    def initialize(result:, body:, debug_id:)
      @result = result
      @body = body
      @debug_id = debug_id
    end
  end
end
