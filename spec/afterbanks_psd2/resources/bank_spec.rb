require "spec_helper"

describe AfterbanksPSD2::Bank do
  describe "#list" do
    before do
      stub_request(:get, "https://apipsd2.afterbanks.com/listOfSupportedBanks/")
        .to_return(
          status: 200,
          body:   response_json(resource: 'bank', action: 'list')
        )
    end

    it "returns the proper AfterbanksPSD2::Bank instances with the adequate name changes" do
      response = AfterbanksPSD2::Bank.list

      expect(response.class).to eq(AfterbanksPSD2::Response)
      expect(response.body).to match_array(
        [
          {
            "countryCode"       => "ES",
            "service"           => "N26",
            "swift"             => "NTSBDEB1",
            "fullname"          => "N26",
            "image"             => "https://www.afterbanks.com/api/icons/n26.min.png",
            "imageSVG"          => "n26",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "ES",
            "service"           => "bbva",
            "swift"             => "BBVAESMM",
            "fullname"          => "BBVA",
            "image"             => "https://www.afterbanks.com/api/icons/bbva.min.png",
            "imageSVG"          => "bbva",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "FR",
            "service"           => "bbva_fr",
            "swift"             => "BBVAESMM",
            "fullname"          => "BBVA France",
            "image"             => "https://www.afterbanks.com/api/icons/bbva.min.png",
            "imageSVG"          => "bbva",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "ES",
            "service"           => "caixa",
            "swift"             => "CAIXESBB",
            "fullname"          => "Caixabank",
            "image"             => "https://www.afterbanks.com/api/icons/caixa.min.png",
            "imageSVG"          => "caixa",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "ES",
            "service"           => "cajaingenieros",
            "swift"             => "CDENESBB",
            "fullname"          => "Caixa d'Enginyers",
            "image"             => "https://www.afterbanks.com/api/icons/cajaingenieros.min.png",
            "imageSVG"          => "cajaingenieros",
            "paymentsSupported" => "0"
          },
          {
            "countryCode"       => "IT",
            "service"           => "paschidisiena_it",
            "swift"             => "PASCITMMXXX",
            "fullname"          => "Monte dei paschi di Siena",
            "image"             => "https://www.afterbanks.com/api/icons/paschidisiena_it.min.png",
            "imageSVG"          => "paschidisiena_it",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "PT",
            "service"           => "catv",
            "swift"             => "CTIUPTP1XXX",
            "fullname"          => "Caixa de CA Mutuo Torres Vedras",
            "image"             => "https://www.afterbanks.com/api/icons/catv.min.png",
            "imageSVG"          => "catv",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "ES",
            "service"           => "sabadell",
            "swift"             => "BSABESBB",
            "fullname"          => "Banco Sabadell",
            "image"             => "https://www.afterbanks.com/api/icons/sabadell.min.png",
            "imageSVG"          => "sabadell",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "ES",
            "service"           => "caixaguissona",
            "swift"             => "CAXIES21XXX",
            "fullname"          => "Caixa Guissona",
            "image"             => "https://www.afterbanks.com/api/icons/cajamar.min.png",
            "imageSVG"          => "cajamar",
            "paymentsSupported" => "0"
          },
          {
            "countryCode"       => "ES",
            "service"           => "caixaruralburriana",
            "swift"             => "CCRIES2A",
            "fullname"          => "Caixa Burriana",
            "image"             => "https://www.afterbanks.com/api/icons/cajamar.min.png",
            "imageSVG"          => "cajamar",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "BE",
            "service"           => "hellobank_be",
            "swift"             => "DIRAAT2S",
            "fullname"          => "Hello Bank",
            "image"             => "https://www.afterbanks.com/api/icons/hellobank_it.min.png",
            "imageSVG"          => "hellobank_it",
            "paymentsSupported" => "1"
          },
          {
            "countryCode"       => "IT",
            "service"           => "chebanca_it",
            "swift"             => "MICSITM1XXX",
            "fullname"          => "CheBanca",
            "image"             => "https://www.afterbanks.com/api/icons/chebanca_it.min.png",
            "imageSVG"          => "chebanca_it",
            "paymentsSupported" => "1"
          }
        ]
      )

      banks = response.result

      expect(banks.class).to eq(AfterbanksPSD2::Collection)
      expect(banks.size).to eq(12)

      bank1, bank2, bank3, bank4, bank5, bank6, bank7, bank8, bank9, bank10, bank11, bank12 = banks

      expect(bank1.class).to eq(AfterbanksPSD2::Bank)
      expect(bank1.country_code).to eq("ES")
      expect(bank1.service).to eq("N26")
      expect(bank1.swift).to eq("NTSBDEB1")
      expect(bank1.fullname).to eq("N26")
      expect(bank1.image).to eq("https://www.afterbanks.com/api/icons/n26.min.png")
      expect(bank1.image_svg).to eq("n26")
      expect(bank1.payments_supported).to be_truthy

      expect(bank2.class).to eq(AfterbanksPSD2::Bank)
      expect(bank2.country_code).to eq("ES")
      expect(bank2.service).to eq("bbva")
      expect(bank2.swift).to eq("BBVAESMM")
      expect(bank2.fullname).to eq("BBVA")
      expect(bank2.image).to eq("https://www.afterbanks.com/api/icons/bbva.min.png")
      expect(bank2.image_svg).to eq("bbva")
      expect(bank2.payments_supported).to be_truthy

      expect(bank3.class).to eq(AfterbanksPSD2::Bank)
      expect(bank3.country_code).to eq("FR")
      expect(bank3.service).to eq("bbva_fr")
      expect(bank3.swift).to eq("BBVAESMM")
      expect(bank3.fullname).to eq("BBVA France")
      expect(bank3.image).to eq("https://www.afterbanks.com/api/icons/bbva.min.png")
      expect(bank3.image_svg).to eq("bbva")
      expect(bank3.payments_supported).to be_truthy

      expect(bank4.class).to eq(AfterbanksPSD2::Bank)
      expect(bank4.country_code).to eq("ES")
      expect(bank4.service).to eq("caixa")
      expect(bank4.swift).to eq("CAIXESBB")
      expect(bank4.fullname).to eq("Caixabank")
      expect(bank4.image).to eq("https://www.afterbanks.com/api/icons/caixa.min.png")
      expect(bank4.image_svg).to eq("caixa")
      expect(bank4.payments_supported).to be_truthy

      expect(bank5.class).to eq(AfterbanksPSD2::Bank)
      expect(bank5.country_code).to eq("ES")
      expect(bank5.service).to eq("cajaingenieros")
      expect(bank5.swift).to eq("CDENESBB")
      expect(bank5.fullname).to eq("Caixa d'Enginyers")
      expect(bank5.image).to eq("https://www.afterbanks.com/api/icons/cajaingenieros.min.png")
      expect(bank5.image_svg).to eq("cajaingenieros")
      expect(bank5.payments_supported).to be_falsey

      expect(bank6.class).to eq(AfterbanksPSD2::Bank)
      expect(bank6.country_code).to eq("IT")
      expect(bank6.service).to eq("paschidisiena_it")
      expect(bank6.swift).to eq("PASCITMMXXX")
      expect(bank6.fullname).to eq("Monte dei paschi di Siena")
      expect(bank6.image).to eq("https://www.afterbanks.com/api/icons/paschidisiena_it.min.png")
      expect(bank6.image_svg).to eq("paschidisiena_it")
      expect(bank6.payments_supported).to be_truthy

      expect(bank7.class).to eq(AfterbanksPSD2::Bank)
      expect(bank7.country_code).to eq("PT")
      expect(bank7.service).to eq("catv")
      expect(bank7.swift).to eq("CTIUPTP1XXX")
      expect(bank7.fullname).to eq("Caixa de CA Mutuo Torres Vedras")
      expect(bank7.image).to eq("https://www.afterbanks.com/api/icons/catv.min.png")
      expect(bank7.image_svg).to eq("catv")
      expect(bank7.payments_supported).to be_truthy

      expect(bank8.class).to eq(AfterbanksPSD2::Bank)
      expect(bank8.country_code).to eq("ES")
      expect(bank8.service).to eq("sabadell")
      expect(bank8.swift).to eq("BSABESBB")
      expect(bank8.fullname).to eq("Banco Sabadell")
      expect(bank8.image).to eq("https://www.afterbanks.com/api/icons/sabadell.min.png")
      expect(bank8.image_svg).to eq("sabadell")
      expect(bank8.payments_supported).to be_truthy

      expect(bank9.class).to eq(AfterbanksPSD2::Bank)
      expect(bank9.country_code).to eq("ES")
      expect(bank9.service).to eq("caixaguissona")
      expect(bank9.swift).to eq("CAXIES21XXX")
      expect(bank9.fullname).to eq("Caixa Guissona")
      expect(bank9.image).to eq("https://www.afterbanks.com/api/icons/cajamar.min.png")
      expect(bank9.image_svg).to eq("cajamar")
      expect(bank9.payments_supported).to be_falsey

      expect(bank10.class).to eq(AfterbanksPSD2::Bank)
      expect(bank10.country_code).to eq("ES")
      expect(bank10.service).to eq("caixaruralburriana")
      expect(bank10.swift).to eq("CCRIES2A")
      expect(bank10.fullname).to eq("Caixa Burriana")
      expect(bank10.image).to eq("https://www.afterbanks.com/api/icons/cajamar.min.png")
      expect(bank10.image_svg).to eq("cajamar")
      expect(bank10.payments_supported).to be_truthy

      expect(bank11.class).to eq(AfterbanksPSD2::Bank)
      expect(bank11.country_code).to eq("BE")
      expect(bank11.service).to eq("hellobank_be")
      expect(bank11.swift).to eq("DIRAAT2S")
      expect(bank11.fullname).to eq("Hello Bank")
      expect(bank11.image).to eq("https://www.afterbanks.com/api/icons/hellobank_it.min.png")
      expect(bank11.image_svg).to eq("hellobank_it")
      expect(bank11.payments_supported).to be_truthy

      expect(bank12.class).to eq(AfterbanksPSD2::Bank)
      expect(bank12.country_code).to eq("IT")
      expect(bank12.service).to eq("chebanca_it")
      expect(bank12.swift).to eq("MICSITM1XXX")
      expect(bank12.fullname).to eq("CheBanca")
      expect(bank12.image).to eq("https://www.afterbanks.com/api/icons/chebanca_it.min.png")
      expect(bank12.image_svg).to eq("chebanca_it")
      expect(bank12.payments_supported).to be_truthy

      expect(bank12.class).to eq(AfterbanksPSD2::Bank)
      expect(bank12.country_code).to eq("IT")
      expect(bank12.service).to eq("chebanca_it")
      expect(bank12.swift).to eq("MICSITM1XXX")
      expect(bank12.fullname).to eq("CheBanca")
      expect(bank12.image).to eq("https://www.afterbanks.com/api/icons/chebanca_it.min.png")
      expect(bank12.image_svg).to eq("chebanca_it")
      expect(bank12.payments_supported).to be_truthy
    end

    context "when passing the :ordered flag" do
      it "returns the proper AfterbanksPSD2::Bank instances with the adequate name changes, ordered by fullname" do
        response = AfterbanksPSD2::Bank.list(ordered: true)

        expect(response.class).to eq(AfterbanksPSD2::Response)

        banks = response.result

        expect(banks.class).to eq(AfterbanksPSD2::Collection)
        expect(banks.size).to eq(12)

        bank1, bank2, bank3, bank4, bank5, bank6, bank7, bank8, bank9, bank10, bank11, bank12 = banks

        expect(bank1.class).to eq(AfterbanksPSD2::Bank)
        expect(bank1.country_code).to eq("ES")
        expect(bank1.service).to eq("sabadell")
        expect(bank1.swift).to eq("BSABESBB")
        expect(bank1.fullname).to eq("Banco Sabadell")
        expect(bank1.image).to eq("https://www.afterbanks.com/api/icons/sabadell.min.png")
        expect(bank1.image_svg).to eq("sabadell")
        expect(bank1.payments_supported).to be_truthy

        expect(bank2.class).to eq(AfterbanksPSD2::Bank)
        expect(bank2.country_code).to eq("ES")
        expect(bank2.service).to eq("bbva")
        expect(bank2.swift).to eq("BBVAESMM")
        expect(bank2.fullname).to eq("BBVA")
        expect(bank2.image).to eq("https://www.afterbanks.com/api/icons/bbva.min.png")
        expect(bank2.image_svg).to eq("bbva")
        expect(bank2.payments_supported).to be_truthy

        expect(bank3.class).to eq(AfterbanksPSD2::Bank)
        expect(bank3.country_code).to eq("FR")
        expect(bank3.service).to eq("bbva_fr")
        expect(bank3.swift).to eq("BBVAESMM")
        expect(bank3.fullname).to eq("BBVA France")
        expect(bank3.image).to eq("https://www.afterbanks.com/api/icons/bbva.min.png")
        expect(bank3.image_svg).to eq("bbva")
        expect(bank3.payments_supported).to be_truthy

        expect(bank4.class).to eq(AfterbanksPSD2::Bank)
        expect(bank4.country_code).to eq("ES")
        expect(bank4.service).to eq("caixaruralburriana")
        expect(bank4.swift).to eq("CCRIES2A")
        expect(bank4.fullname).to eq("Caixa Burriana")
        expect(bank4.image).to eq("https://www.afterbanks.com/api/icons/cajamar.min.png")
        expect(bank4.image_svg).to eq("cajamar")
        expect(bank4.payments_supported).to be_truthy

        expect(bank5.class).to eq(AfterbanksPSD2::Bank)
        expect(bank5.country_code).to eq("ES")
        expect(bank5.service).to eq("cajaingenieros")
        expect(bank5.swift).to eq("CDENESBB")
        expect(bank5.fullname).to eq("Caixa d'Enginyers")
        expect(bank5.image).to eq("https://www.afterbanks.com/api/icons/cajaingenieros.min.png")
        expect(bank5.image_svg).to eq("cajaingenieros")
        expect(bank5.payments_supported).to be_falsey

        expect(bank6.class).to eq(AfterbanksPSD2::Bank)
        expect(bank6.country_code).to eq("PT")
        expect(bank6.service).to eq("catv")
        expect(bank6.swift).to eq("CTIUPTP1XXX")
        expect(bank6.fullname).to eq("Caixa de CA Mutuo Torres Vedras")
        expect(bank6.image).to eq("https://www.afterbanks.com/api/icons/catv.min.png")
        expect(bank6.image_svg).to eq("catv")
        expect(bank6.payments_supported).to be_truthy

        expect(bank7.class).to eq(AfterbanksPSD2::Bank)
        expect(bank7.country_code).to eq("ES")
        expect(bank7.service).to eq("caixaguissona")
        expect(bank7.swift).to eq("CAXIES21XXX")
        expect(bank7.fullname).to eq("Caixa Guissona")
        expect(bank7.image).to eq("https://www.afterbanks.com/api/icons/cajamar.min.png")
        expect(bank7.image_svg).to eq("cajamar")
        expect(bank7.payments_supported).to be_falsey

        expect(bank8.class).to eq(AfterbanksPSD2::Bank)
        expect(bank8.country_code).to eq("ES")
        expect(bank8.service).to eq("caixa")
        expect(bank8.swift).to eq("CAIXESBB")
        expect(bank8.fullname).to eq("Caixabank")
        expect(bank8.image).to eq("https://www.afterbanks.com/api/icons/caixa.min.png")
        expect(bank8.image_svg).to eq("caixa")
        expect(bank8.payments_supported).to be_truthy

        expect(bank9.class).to eq(AfterbanksPSD2::Bank)
        expect(bank9.country_code).to eq("IT")
        expect(bank9.service).to eq("chebanca_it")
        expect(bank9.swift).to eq("MICSITM1XXX")
        expect(bank9.fullname).to eq("CheBanca")
        expect(bank9.image).to eq("https://www.afterbanks.com/api/icons/chebanca_it.min.png")
        expect(bank9.image_svg).to eq("chebanca_it")
        expect(bank9.payments_supported).to be_truthy

        expect(bank10.class).to eq(AfterbanksPSD2::Bank)
        expect(bank10.country_code).to eq("BE")
        expect(bank10.service).to eq("hellobank_be")
        expect(bank10.swift).to eq("DIRAAT2S")
        expect(bank10.fullname).to eq("Hello Bank")
        expect(bank10.image).to eq("https://www.afterbanks.com/api/icons/hellobank_it.min.png")
        expect(bank10.image_svg).to eq("hellobank_it")
        expect(bank10.payments_supported).to be_truthy

        expect(bank11.class).to eq(AfterbanksPSD2::Bank)
        expect(bank11.country_code).to eq("IT")
        expect(bank11.service).to eq("paschidisiena_it")
        expect(bank11.swift).to eq("PASCITMMXXX")
        expect(bank11.fullname).to eq("Monte dei paschi di Siena")
        expect(bank11.image).to eq("https://www.afterbanks.com/api/icons/paschidisiena_it.min.png")
        expect(bank11.image_svg).to eq("paschidisiena_it")
        expect(bank11.payments_supported).to be_truthy

        expect(bank12.class).to eq(AfterbanksPSD2::Bank)
        expect(bank12.country_code).to eq("ES")
        expect(bank12.service).to eq("N26")
        expect(bank12.swift).to eq("NTSBDEB1")
        expect(bank12.fullname).to eq("N26")
        expect(bank12.image).to eq("https://www.afterbanks.com/api/icons/n26.min.png")
        expect(bank12.image_svg).to eq("n26")
        expect(bank12.payments_supported).to be_truthy
      end
    end

    context "when passing the :countries flag" do
      context "with one country" do
        it "returns the proper AfterbanksPSD2::Bank instances with the adequate name changes, for that country" do
          response = AfterbanksPSD2::Bank.list(country_codes: ['it'])

          expect(response.class).to eq(AfterbanksPSD2::Response)

          banks = response.result

          expect(banks.class).to eq(AfterbanksPSD2::Collection)
          expect(banks.size).to eq(2)

          bank1, bank2 = banks

          expect(bank1.class).to eq(AfterbanksPSD2::Bank)
          expect(bank1.country_code).to eq("IT")
          expect(bank1.service).to eq("paschidisiena_it")
          expect(bank1.swift).to eq("PASCITMMXXX")
          expect(bank1.fullname).to eq("Monte dei paschi di Siena")
          expect(bank1.image).to eq("https://www.afterbanks.com/api/icons/paschidisiena_it.min.png")
          expect(bank1.image_svg).to eq("paschidisiena_it")
          expect(bank1.payments_supported).to be_truthy

          expect(bank2.class).to eq(AfterbanksPSD2::Bank)
          expect(bank2.country_code).to eq("IT")
          expect(bank2.service).to eq("chebanca_it")
          expect(bank2.swift).to eq("MICSITM1XXX")
          expect(bank2.fullname).to eq("CheBanca")
          expect(bank2.image).to eq("https://www.afterbanks.com/api/icons/chebanca_it.min.png")
          expect(bank2.image_svg).to eq("chebanca_it")
          expect(bank2.payments_supported).to be_truthy
        end
      end

      context "with many countries" do
        it "returns the proper AfterbanksPSD2::Bank instances with the adequate name changes, for those countries" do
          response = AfterbanksPSD2::Bank.list(country_codes: ['pt', 'be'])

          expect(response.class).to eq(AfterbanksPSD2::Response)

          banks = response.result

          expect(banks.class).to eq(AfterbanksPSD2::Collection)
          expect(banks.size).to eq(2)

          bank1, bank2 = banks

          expect(bank1.class).to eq(AfterbanksPSD2::Bank)
          expect(bank1.country_code).to eq("PT")
          expect(bank1.service).to eq("catv")
          expect(bank1.swift).to eq("CTIUPTP1XXX")
          expect(bank1.fullname).to eq("Caixa de CA Mutuo Torres Vedras")
          expect(bank1.image).to eq("https://www.afterbanks.com/api/icons/catv.min.png")
          expect(bank1.image_svg).to eq("catv")
          expect(bank1.payments_supported).to be_truthy

          expect(bank2.class).to eq(AfterbanksPSD2::Bank)
          expect(bank2.country_code).to eq("BE")
          expect(bank2.service).to eq("hellobank_be")
          expect(bank2.swift).to eq("DIRAAT2S")
          expect(bank2.fullname).to eq("Hello Bank")
          expect(bank2.image).to eq("https://www.afterbanks.com/api/icons/hellobank_it.min.png")
          expect(bank2.image_svg).to eq("hellobank_it")
          expect(bank2.payments_supported).to be_truthy
        end
      end
    end
  end

  describe "serialization" do
    let(:country_code) { 'ES' }
    let(:service) { 'N26' }
    let(:swift) { 'NTSBDEB1' }
    let(:fullname) { 'N26' }
    let(:image) { 'https://www.afterbanks.com/api/icons/n26.min.png' }
    let(:image_svg) { 'n26' }
    let(:payments_supported) { true }

    let(:original_bank) do
      AfterbanksPSD2::Bank.new(
        country_code:       country_code,
        service:            service,
        swift:              swift,
        fullname:           fullname,
        image:              image,
        image_svg:          image_svg,
        payments_supported: payments_supported
      )
    end

    it "works" do
      serialized_bank = Marshal.dump(original_bank)
      recovered_bank = Marshal.load(serialized_bank)

      expect(recovered_bank.class).to eq(AfterbanksPSD2::Bank)
      expect(recovered_bank.country_code).to eq("ES")
      expect(recovered_bank.service).to eq("N26")
      expect(recovered_bank.swift).to eq("NTSBDEB1")
      expect(recovered_bank.fullname).to eq("N26")
      expect(recovered_bank.image).to eq("https://www.afterbanks.com/api/icons/n26.min.png")
      expect(recovered_bank.image_svg).to eq("n26")
      expect(recovered_bank.payments_supported).to be_truthy
    end
  end
end
