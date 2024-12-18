module AfterbanksPSD2
  class Error < ::StandardError
    attr_reader :message, :debug_id

    def initialize(message:, debug_id:)
      super

      @message = message
      @debug_id = debug_id
    end

    def code
      raise 'Not implemented'
    end
  end

  class GenericError < Error
    def code
      1
    end
  end

  class IncorrectParametersError < Error
    def code
      50
    end
  end

  class GenericConsentError < Error
    def code
      'C000'
    end
  end

  class InvalidConsentError < Error
    def code
      'C001'
    end
  end

  class ConsentWithUnfinalizedProcessError < Error
    def code
      'C002'
    end
  end

  class ProductMismatchConsentError < Error
    def code
      'C003'
    end
  end

  class ExpiredConsentError < Error
    def code
      'C004'
    end
  end

  class MaximumNumberOfCallsReachedConsentError < Error
    def code
      'C005'
    end
  end

  class GenericTransactionError < Error
    def code
      'T000'
    end
  end

  class InvalidConsentForProductError < Error
    def code
      'T001'
    end
  end

  class AccountNotFoundError < Error
    def code
      'P000'
    end
  end
end
