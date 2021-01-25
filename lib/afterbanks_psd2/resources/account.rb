module AfterbanksPSD2
  class Account < Resource
    has_fields product:           { type: :string },
               type:              { type: :string },
               balance:           { type: :decimal },
               countable_balance: { type: :decimal },
               arranged_balance:  { type: :decimal },
               currency:          { type: :string },
               description:       { type: :string },
               iban:              { type: :string },
               is_owner:          { type: :boolean },
               holders:           { type: :hash }

    def self.list(token:)
      params = {
        servicekey: AfterbanksPSD2.configuration.servicekey,
        token:      token,
        products:   'GLOBAL'
      }

      response, debug_id = AfterbanksPSD2.api_call(
        method: :post,
        path:   '/transactions/',
        params: params
      )

      Response.new(
        result:   Collection.new(
          response,
          self
        ),
        debug_id: debug_id
      )
    end
  end
end
