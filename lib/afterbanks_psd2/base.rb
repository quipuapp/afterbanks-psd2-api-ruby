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
  end
end
