require 'rest-client'
require 'json'

module AfterbanksPSD2
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def api_call(method:, path:, params: {})
      url = 'https://apipsd2.afterbanks.com' + path

      request_params = { method: method, url: url }

      if method == :post
        request_params.merge!(payload: params)
      else
        request_params.merge!(headers: { params: params })
      end

      response = begin
        RestClient::Request.execute(request_params)
      rescue RestClient::BadRequest, RestClient::ExpectationFailed => bad_request
        # Check
        bad_request.response
      end

      debug_id = response.headers[:debug_id]

      log_request(
        method:   method,
        url:      url,
        params:   params,
        debug_id: debug_id
      )

      response_body = JSON.parse(response.body)

      treat_errors_if_any(
        response_body: response_body,
        debug_id:      debug_id
      )

      [response_body, debug_id]
    end

    def log_request(method:, url:, params: {}, debug_id: nil)
      logger = AfterbanksPSD2.configuration.logger
      return if logger.nil?

      now = Time.now

      safe_params = {}
      params.each do |key, value|
        safe_value = if %w{servicekey}.include?(key.to_s)
                       "<masked>"
                     else
                       value
                     end

        safe_value = safe_value.to_s if safe_value.is_a?(Symbol)

        safe_params[key] = safe_value
      end

      logger.info(
        message:   'Afterbanks PSD2 request',
        method:    method.upcase.to_s,
        url:       url,
        time:      now.to_s,
        timestamp: now.to_i,
        debug_id:  debug_id || 'none',
        params:    safe_params
      )
    end

    def treat_errors_if_any(response_body:, debug_id:)
      return unless response_body.is_a?(Hash)

      code = response_body['code']
      integer_code = code.to_i
      if integer_code.to_s == code
        code = integer_code
      end

      message = response_body['message']

      error_info = { message: message, debug_id: debug_id }

      case code
      when 1
        raise GenericError.new(**error_info)
      when 50
        raise IncorrectParametersError.new(**error_info)
      when 'C000'
        raise GenericConsentError.new(**error_info)
      when 'C001'
        raise InvalidConsentError.new(**error_info)
      when 'C002'
        raise ConsentWithUnfinalizedProcessError.new(**error_info)
      when 'C003'
        raise ProductMismatchConsentError.new(**error_info)
      when 'C004'
        raise ExpiredConsentError.new(**error_info)
      when 'C005'
        raise MaximumNumberOfCallsReachedConsentError.new(**error_info)
      when 'T000'
        raise GenericTransactionError.new(**error_info)
      when 'T001'
        raise InvalidConsentForProductError.new(**error_info)
      end

      nil
    end
  end
end
