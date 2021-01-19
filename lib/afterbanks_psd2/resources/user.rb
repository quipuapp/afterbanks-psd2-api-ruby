module AfterbanksPSD2
  class User < Resource
    has_fields limit: { type: :integer },
               counter: { type: :integer },
               remaining_calls: { type: :integer },
               date_renewal: { type: :date },
               detail: { type: :string }

    def self.get
      response, debug_id = AfterbanksPSD2.api_call(
        method: :post,
        path: '/me/',
        params: {
          servicekey: AfterbanksPSD2.configuration.servicekey
        }
      )

      Response.new(
        result: new(response)
      )
    end
  end
end
