module AfterbanksPSD2
  class Bank < Resource
    has_fields country_code: { type: :string, original_name: :countryCode },
               service: { type: :string },
               swift: { type: :string },
               fullname: { type: :string },
               image: { type: :string },
               image_svg: { type: :string, original_name: :imageSVG },
               payments_supported: { type: :boolean, original_name: :paymentsSupported }

    def self.list(ordered: false, country_codes: nil)
      response = AfterbanksPSD2.api_call(
        method: :get,
        path: '/listOfSupportedBanks/'
      )

      Response.new(
        result: Collection.new(
          banks_information_for(
            response: response,
            ordered: ordered,
            country_codes: country_codes
          ),
          self
        )
      )
    end

    private

    def self.banks_information_for(response:, ordered:, country_codes:)
      country_codes = country_codes.map(&:upcase) unless country_codes.nil?
      banks_information = []

      services_number_by_bank_id = {}
      response.each do |bank_information|
        bank_id = bank_id_for(bank_information: bank_information)
        services_number_by_bank_id[bank_id] ||= 0
        services_number_by_bank_id[bank_id] += 1
      end

      response.each do |bank_information|
        next if country_codes && !country_codes.include?(bank_information['countryCode'])

        bank_information['fullname'] = bank_name_for(
          bank_information: bank_information,
          services_number_by_bank_id: services_number_by_bank_id
        )

        banks_information << bank_information
      end

      if ordered
        banks_information.sort! do |bank_information1, bank_information2|
          bank_information1['fullname'].downcase <=> bank_information2['fullname'].downcase
        end
      end

      banks_information
    end

    def self.bank_name_for(bank_information:, services_number_by_bank_id:)
      # Name changes:
      # 1. Add Particulares and Empresas if there are different personal/company endpoints
      # 2. Rename Caja Ingenieros into Caixa d'Enginyers (most known name)
      # 3. Rename Caixa Guisona into Caixa Guissona (fix typo)
      # 4. Rename Caixa burriana into Caixa Burriana (fix typo)

      if special_name = special_name_for_service(service: bank_information['service'])
        return special_name
      end

      bank_id = bank_id_for(bank_information: bank_information)
      service = bank_information['service']
      fullname = bank_information['fullname']

      if services_number_by_bank_id[bank_id] == 2
        suffix = service =~ /_emp\z/ ? 'Empresas' : 'Particulares'

        return [fullname, suffix].join(" ")
      end

      fullname
    end

    def self.bank_id_for(bank_information:)
      bank_information['service'].split("_").first
    end

    def self.special_name_for_service(service:)
      case service
      when 'cajaingenieros'
        "Caixa d'Enginyers"
      when 'caixaguissona'
        "Caixa Guissona"
      when 'caixaruralburriana'
        "Caixa Burriana"
      else
        nil
      end
    end
  end
end
