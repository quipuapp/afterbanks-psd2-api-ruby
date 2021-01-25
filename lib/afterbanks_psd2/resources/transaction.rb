module AfterbanksPSD2
  class Transaction < Resource
    has_fields date:           { type: :date },
               date2:          { type: :date },
               amount:         { type: :decimal },
               description:    { type: :string },
               balance:        { type: :decimal },
               transaction_id: { type: :string, original_name: :transactionId },
               category_id:    { type: :integer, original_name: :categoryId },
               account:        { type: :afterbankspsd2_account }

    def self.list(token:, products:, start_date:)
      params = {
        servicekey: AfterbanksPSD2.configuration.servicekey,
        token:      token,
        products:   products,
        startDate:  start_date.strftime("%d-%m-%Y")
      }

      response, debug_id = AfterbanksPSD2.api_call(
        method: :post,
        path:   '/transactions/',
        params: params
      )

      Response.new(
        result:   Collection.new(
          transactions_information_for(
            response: response,
            products: products
          ),
          self
        ),
        debug_id: debug_id
      )
    end

    def self.transactions_information_for(response:, products:)
      transactions_information = []
      products_array = products.split(",")

      response.each do |account_information|
        product = account_information['product']

        next unless products_array.include?(product)

        transactions = account_information['transactions']
        next if transactions.nil? || transactions.empty?

        account = AfterbanksPSD2::Account.new(account_information)

        transactions.each do |transaction|
          transaction['account'] = account
        end

        transactions_information += transactions
      end

      transactions_information
    end
  end
end
