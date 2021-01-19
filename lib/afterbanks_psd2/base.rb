require 'rest-client'
require 'json'

module AfterbanksPSD2
  class << self
    def api_call(method:, path:, params: {})
      url = 'https://apipsd2.afterbanks.com' + path

      request_params = { method: method, url: url }

      request_params.merge!(headers: { params: params })

      response = begin
        RestClient::Request.execute(request_params)
      rescue RestClient::BadRequest, RestClient::ExpectationFailed => bad_request
        # Check
        bad_request.response
      end

      JSON.parse(response.body)
    end
  end
end
