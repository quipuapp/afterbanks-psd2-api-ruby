require "spec_helper"

describe AfterbanksPSD2::Account do
  describe "#list" do
    let(:token) { 'a_token' }
    let(:body) {
      {
        "servicekey" => 'a_servicekey_which_works',
        "token"      => token,
        "products"   => 'GLOBAL'
      }
    }
    let(:api_call) {
      AfterbanksPSD2::Account.list(
        token: token
      )
    }

    context "when returning data" do
      before do
        stub_request(:post, "https://apipsd2.afterbanks.com/transactions/")
          .with(body: body)
          .to_return(
            status:  200,
            body:    response_json(resource: 'account', action: 'list'),
            headers: { debug_id: 'acclist1234' }
          )
      end

      it "does the proper request and returns the proper AfterbanksPSD2::Account instances" do
        response = api_call

        expect(response.class).to eq(AfterbanksPSD2::Response)
        expect(response.debug_id).to eq('acclist1234')

        accounts = response.result

        expect(accounts.class).to eq(AfterbanksPSD2::Collection)
        expect(accounts.size).to eq(3)

        account1, account2, account3 = accounts

        expect(account1.class).to eq(AfterbanksPSD2::Account)
        expect(account1.product).to eq("ES2720809591124344566256")
        expect(account1.type).to eq("checking")
        expect(account1.balance).to eq(1094.12)
        expect(account1.countable_balance).to eq(1081.13)
        expect(account1.arranged_balance).to eq(1143.71)
        expect(account1.currency).to eq("EUR")
        expect(account1.description).to eq("A checking account")
        expect(account1.iban).to eq("ES2720809591124344566256")
        expect(account1.is_owner).to be_truthy
        expect(account1.holders).to eq(
          [
            { "role" => 'Admin', "name" => 'Mary', "id" => 1 },
            { "role" => 'Admin', "name" => 'Liz', "id" => 2 },
            { "role" => 'Supervisor', "name" => 'John', "id" => 3 }
          ]
        )

        expect(account2.class).to eq(AfterbanksPSD2::Account)
        expect(account2.product).to eq("ES8401821618664757634169")
        expect(account2.type).to eq("checking")
        expect(account2.balance).to eq(216.19)
        expect(account2.countable_balance).to eq(220.44)
        expect(account2.arranged_balance).to eq(213.4)
        expect(account2.currency).to eq("EUR")
        expect(account2.description).to eq("Another checking account")
        expect(account2.iban).to eq("ES8401821618664757634169")
        expect(account2.is_owner).to be_truthy
        expect(account2.holders).to eq(
          [
            { "role" => 'Admin', "name" => 'Mary', "id" => 11 }
          ]
        )

        expect(account3.class).to eq(AfterbanksPSD2::Account)
        expect(account3.product).to eq("ES9231902434113168967688")
        expect(account3.type).to eq("loan")
        expect(account3.balance).to eq(-91.99)
        expect(account3.countable_balance).to eq(-86.71)
        expect(account3.arranged_balance).to eq(-99.13)
        expect(account3.currency).to eq("USD")
        expect(account3.description).to eq("A loan")
        expect(account3.iban).to eq("ES9231902434113168967688")
        expect(account3.is_owner).to be_falsey
        expect(account3.holders).to eq(
          [
            { "role" => 'Admin', "name" => 'Sandy', "id" => 12 },
            { "role" => 'Supervisor', "name" => 'Joe', "id" => 34 }
          ]
        )
      end
    end

    context "when returning an empty response" do
      before do
        stub_request(:post, "https://apipsd2.afterbanks.com/transactions/")
          .with(body: body)
          .to_return(
            status:  200,
            body:    response_json(resource: 'account', action: 'empty'),
            headers: { debug_id: 'acclist1234' }
          )
      end

      it "does the proper request and returns the proper AfterbanksPSD2::Account instances" do
        response = api_call

        expect(response.class).to eq(AfterbanksPSD2::Response)
        expect(response.debug_id).to eq('acclist1234')

        accounts = response.result

        expect(accounts.class).to eq(AfterbanksPSD2::Collection)
        expect(accounts.size).to eq(0)
      end
    end

    context "when returning an error" do
      before do
        stub_request(:post, "https://apipsd2.afterbanks.com/transactions/")
          .with(body: body)
          .to_return(
            status:  200,
            body:    response_json(resource: 'errors', action: error),
            headers: { debug_id: 'acclist1234' }
          )
      end

      context "which is 1 (generic)" do
        let(:error) { '1' }

        it "raises a GenericError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::GenericError)
              .and having_attributes(
                code:    1,
                message: "Error genérico"
              )
          )
        end
      end

      context "which is 50 (incorrect parameters)" do
        let(:error) { '50' }

        it "raises a IncorrectParametersError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::IncorrectParametersError)
              .and having_attributes(
                code:    50,
                message: "Parámetro incorrecto en la llamada a la API"
              )
          )
        end
      end

      context "which is C000 (generic)" do
        let(:error) { 'C000' }

        it "raises a GenericConsentError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::GenericConsentError)
              .and having_attributes(
                code:    'C000',
                message: "Error genérico con el consentimiento"
              )
          )
        end
      end

      context "which is C001 (generic, consent variant)" do
        let(:error) { 'C001' }

        it "raises a InvalidConsentError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::InvalidConsentError)
              .and having_attributes(
                code:    'C001',
                message: "Consentimiento inválido"
              )
          )
        end
      end

      context "which is C002 (consent has not finalized the setup process)" do
        let(:error) { 'C002' }

        it "raises a ConsentWithUnfinalizedProcessError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::ConsentWithUnfinalizedProcessError)
              .and having_attributes(
                code:    'C002',
                message: "Proceso de consentimiento no ha sido finalizado"
              )
          )
        end
      end

      context "which is C003 (product mismatch with the consent, consent variant)" do
        let(:error) { 'C003' }

        it "raises a ProductMismatchConsentError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::ProductMismatchConsentError)
              .and having_attributes(
                code:    'C003',
                message: "El consentimiento no ha sido creado para el producto solicitado"
              )
          )
        end
      end

      context "which is C004 (expired consent)" do
        let(:error) { 'C004' }

        it "raises a ExpiredConsentError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::ExpiredConsentError)
              .and having_attributes(
                code:    'C004',
                message: "Consentimiento expirado"
              )
          )
        end
      end

      context "which is C005 (consent has reached maximum number of calls)" do
        let(:error) { 'C005' }

        it "raises a MaximumNumberOfCallsReachedConsentError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::MaximumNumberOfCallsReachedConsentError)
              .and having_attributes(
                code:    'C005',
                message: "El consentimiento ha alcanzado el límite diario permitido"
              )
          )
        end
      end
    end
  end
end
