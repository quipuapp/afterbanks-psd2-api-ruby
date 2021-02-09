module AfterbanksPSD2
  class Bank < Resource
    has_fields country_code:       { type: :string, original_name: :countryCode },
               service:            { type: :string },
               swift:              { type: :string },
               fullname:           { type: :string },
               image:              { type: :string },
               image_svg:          { type: :string, original_name: :imageSVG },
               payments_supported: { type: :boolean, original_name: :paymentsSupported }

    def self.list(ordered: false, country_codes: nil)
      response, debug_id = AfterbanksPSD2.api_call(
        method: :get,
        path:   '/listOfSupportedBanks/'
      )

      Response.new(
        result:   Collection.new(
          banks_information_for(
            response:      response,
            ordered:       ordered,
            country_codes: country_codes
          ),
          self
        ),
        debug_id: debug_id
      )
    end

    def self.banks_information_for(response:, ordered:, country_codes:)
      country_codes = country_codes.map(&:upcase) unless country_codes.nil?
      banks_information = []

      response.each do |bank_information|
        next if country_codes && !country_codes.include?(bank_information['countryCode'])

        bank_information['fullname'] = bank_name_for(bank_information: bank_information)

        banks_information << bank_information
      end

      if ordered
        banks_information.sort! do |bank_information1, bank_information2|
          bank_information1['fullname'].downcase <=> bank_information2['fullname'].downcase
        end
      end

      banks_information
    end

    def self.bank_name_for(bank_information:)
      service = bank_information['service']

      # Name changes:

      # 1. Rename Caja Ingenieros into Caixa d'Enginyers (most known name)
      return "Caixa d'Enginyers" if service == 'cajaingenieros'

      # 2. Rename Caixa Guisona into Caixa Guissona (fix typo)
      return "Caixa Guissona" if service == 'caixaguissona'

      # 3. Rename Caixa burriana into Caixa Burriana (fix typo)
      return "Caixa Burriana" if service == 'caixaruralburriana'

      bank_information['fullname']
    end

    def self.bank_id_for(bank_information:)
      bank_information['service'].split("_").first
    end
  end
end
