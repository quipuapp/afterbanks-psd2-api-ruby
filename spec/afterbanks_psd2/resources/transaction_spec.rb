require "spec_helper"

describe AfterbanksPSD2::Transaction do
  describe "#list" do
    let(:token) { 'a_token' }
    let(:products) { 'ES2720809591124344566256,ES8401821618664757634169,ES9231902434113168967688' }
    let(:start_date) { Date.new(2020, 3, 24) }
    let(:body) {
      {
        "servicekey" => 'a_servicekey_which_works',
        "token"      => token,
        "products"   => products,
        "startDate"  => start_date.strftime("%d-%m-%Y")
      }
    }
    let(:api_call) {
      AfterbanksPSD2::Transaction.list(
        token:      token,
        products:   products,
        start_date: start_date
      )
    }

    context "when the start_date is older than 90 days" do
      let(:start_date) { Date.new(2020, 1, 1) }

      it "increases the timeout to 2 hours" do
        expect(RestClient::Request).to receive(:execute).with(
          hash_including(
            timeout: 7200
          )
        ).and_return(
          double(body: '{}', headers: { debug_id: 'acclist1234' })
        )

        api_call
      end
    end

    context "when returning data" do
      before do
        stub_request(:post, "https://apipsd2.afterbanks.com/transactions/")
          .with(body: body)
          .to_return(
            status:  200,
            body:    response_json(resource: 'transaction', action: 'list'),
            headers: { debug_id: 'translist1234' }
          )
      end

      it "does the proper request and returns the proper AfterbanksPSD2::Transaction instances" do
        response = api_call

        expect(response.class).to eq(AfterbanksPSD2::Response)
        expect(response.body).to match_array(
          [
            {
              "product"           => "ES2720809591124344566256",
              "type"              => "checking",
              "balance"           => 1094.12,
              "countable_balance" => 1081.13,
              "arranged_balance"  => 1143.71,
              "currency"          => "EUR",
              "description"       => "A checking account",
              "iban"              => "ES2720809591124344566256",
              "is_owner"          => 1,
              "holders"           => [
                {
                  "role" => "Admin",
                  "name" => "Mary",
                  "id"   => 1
                },
                {
                  "role" => "Admin",
                  "name" => "Liz",
                  "id"   => 2
                },
                {
                  "role" => "Supervisor",
                  "name" => "John",
                  "id"   => 3
                }
              ],
              "transactions"      => [
                {
                  "date"          => "01-02-2020",
                  "date2"         => "02-02-2020",
                  "amount"        => 123.11,
                  "balance"       => 1094.12,
                  "description"   => "Some money in",
                  "categoryId"    => 19,
                  "transactionId" => "abcd1234",
                  "account"       => an_object_having_attributes(
                    class:             AfterbanksPSD2::Account,
                    product:           "ES2720809591124344566256",
                    type:              'checking',
                    balance:           1094.12,
                    countable_balance: 1081.13,
                    arranged_balance:  1143.71,
                    currency:          'EUR',
                    description:       'A checking account',
                    iban:              'ES2720809591124344566256',
                    is_owner:          true,
                    holders:           [
                      {
                        "role" => "Admin",
                        "name" => "Mary",
                        "id"   => 1
                      },
                      {
                        "role" => "Admin",
                        "name" => "Liz",
                        "id"   => 2
                      },
                      {
                        "role" => "Supervisor",
                        "name" => "John",
                        "id"   => 3
                      }
                    ]
                  )
                },
                {
                  "date"          => "20-01-2020",
                  "date2"         => "20-01-2020",
                  "amount"        => -29.58,
                  "balance"       => 971.01,
                  "description"   => "A small purchase",
                  "categoryId"    => 6,
                  "transactionId" => "defg4321",
                  "account"       => an_object_having_attributes(
                    class:             AfterbanksPSD2::Account,
                    product:           "ES2720809591124344566256",
                    type:              'checking',
                    balance:           1094.12,
                    countable_balance: 1081.13,
                    arranged_balance:  1143.71,
                    currency:          'EUR',
                    description:       'A checking account',
                    iban:              'ES2720809591124344566256',
                    is_owner:          true,
                    holders:           [
                      {
                        "role" => "Admin",
                        "name" => "Mary",
                        "id"   => 1
                      },
                      {
                        "role" => "Admin",
                        "name" => "Liz",
                        "id"   => 2
                      },
                      {
                        "role" => "Supervisor",
                        "name" => "John",
                        "id"   => 3
                      }
                    ]
                  )
                },
                {
                  "date"          => "15-01-2020",
                  "date2"         => "15-01-2020",
                  "amount"        => -467.12,
                  "balance"       => 1000.59,
                  "description"   => "A big purchase",
                  "categoryId"    => 12,
                  "transactionId" => "ghij1928",
                  "account"       => an_object_having_attributes(
                    class:             AfterbanksPSD2::Account,
                    product:           "ES2720809591124344566256",
                    type:              'checking',
                    balance:           1094.12,
                    countable_balance: 1081.13,
                    arranged_balance:  1143.71,
                    currency:          'EUR',
                    description:       'A checking account',
                    iban:              'ES2720809591124344566256',
                    is_owner:          true,
                    holders:           [
                      {
                        "role" => "Admin",
                        "name" => "Mary",
                        "id"   => 1
                      },
                      {
                        "role" => "Admin",
                        "name" => "Liz",
                        "id"   => 2
                      },
                      {
                        "role" => "Supervisor",
                        "name" => "John",
                        "id"   => 3
                      }
                    ]
                  )
                },
                {
                  "date"          => "01-01-2019",
                  "date2"         => "01-01-2019",
                  "amount"        => 1467.71,
                  "balance"       => 1467.71,
                  "description"   => "Initial transaction",
                  "categoryId"    => 3,
                  "transactionId" => "jklm5647",
                  "account"       => an_object_having_attributes(
                    class:             AfterbanksPSD2::Account,
                    product:           "ES2720809591124344566256",
                    type:              'checking',
                    balance:           1094.12,
                    countable_balance: 1081.13,
                    arranged_balance:  1143.71,
                    currency:          'EUR',
                    description:       'A checking account',
                    iban:              'ES2720809591124344566256',
                    is_owner:          true,
                    holders:           [
                      {
                        "role" => "Admin",
                        "name" => "Mary",
                        "id"   => 1
                      },
                      {
                        "role" => "Admin",
                        "name" => "Liz",
                        "id"   => 2
                      },
                      {
                        "role" => "Supervisor",
                        "name" => "John",
                        "id"   => 3
                      }
                    ]
                  )
                }
              ]
            },
            {
              "product"           => "ES8401821618664757634169",
              "type"              => "checking",
              "balance"           => 216.19,
              "countable_balance" => 220.44,
              "arranged_balance"  => 213.4,
              "currency"          => "EUR",
              "description"       => "Another checking account",
              "iban"              => "ES8401821618664757634169",
              "is_owner"          => 1,
              "holders"           => [
                {
                  "role" => "Admin",
                  "name" => "Mary",
                  "id"   => 11
                }
              ]
            },
            {
              "product"           => "ES9231902434113168967688",
              "type"              => "loan",
              "balance"           => -91.99,
              "countable_balance" => -86.71,
              "arranged_balance"  => -99.13,
              "currency"          => "USD",
              "description"       => "A loan",
              "iban"              => "ES9231902434113168967688",
              "is_owner"          => 0,
              "holders"           => [
                {
                  "role" => "Admin",
                  "name" => "Sandy",
                  "id"   => 12
                },
                {
                  "role" => "Supervisor",
                  "name" => "Joe",
                  "id"   => 34
                }
              ],
              "transactions"      => [
                {
                  "date"          => "01-04-2021",
                  "date2"         => "01-04-2021",
                  "amount"        => 818.13,
                  "balance"       => 818.13,
                  "description"   => "Black sheep transaction",
                  "categoryId"    => 2,
                  "transactionId" => "mnop1987",
                  "account"       => an_object_having_attributes(
                    class:             AfterbanksPSD2::Account,
                    product:           "ES9231902434113168967688",
                    type:              'loan',
                    balance:           -91.99,
                    countable_balance: -86.71,
                    arranged_balance:  -99.13,
                    currency:          'USD',
                    description:       'A loan',
                    iban:              'ES9231902434113168967688',
                    is_owner:          false,
                    holders:           [
                      {
                        "role" => "Admin",
                        "name" => "Sandy",
                        "id"   => 12
                      },
                      {
                        "role" => "Supervisor",
                        "name" => "Joe",
                        "id"   => 34
                      }
                    ]
                  )
                }
              ]
            }
          ]
        )
        expect(response.debug_id).to eq('translist1234')

        transactions = response.result

        expect(transactions.class).to eq(AfterbanksPSD2::Collection)
        expect(transactions.size).to eq(5)

        transaction1, transaction2, transaction3, transaction4, transaction5 = transactions

        expect(transaction1.class).to eq(AfterbanksPSD2::Transaction)
        expect(transaction1.date).to eq(Date.new(2020, 2, 1))
        expect(transaction1.date2).to eq(Date.new(2020, 2, 2))
        expect(transaction1.amount).to eq(123.11)
        expect(transaction1.balance).to eq(1094.12)
        expect(transaction1.description).to eq("Some money in")
        expect(transaction1.category_id).to eq(19)
        expect(transaction1.transaction_id).to eq("abcd1234")

        expect(transaction2.class).to eq(AfterbanksPSD2::Transaction)
        expect(transaction2.date).to eq(Date.new(2020, 1, 20))
        expect(transaction2.date2).to eq(Date.new(2020, 1, 20))
        expect(transaction2.amount).to eq(-29.58)
        expect(transaction2.balance).to eq(971.01)
        expect(transaction2.description).to eq("A small purchase")
        expect(transaction2.category_id).to eq(6)
        expect(transaction2.transaction_id).to eq("defg4321")

        expect(transaction3.class).to eq(AfterbanksPSD2::Transaction)
        expect(transaction3.date).to eq(Date.new(2020, 1, 15))
        expect(transaction3.date2).to eq(Date.new(2020, 1, 15))
        expect(transaction3.amount).to eq(-467.12)
        expect(transaction3.balance).to eq(1000.59)
        expect(transaction3.description).to eq("A big purchase")
        expect(transaction3.category_id).to eq(12)
        expect(transaction3.transaction_id).to eq("ghij1928")

        expect(transaction4.class).to eq(AfterbanksPSD2::Transaction)
        expect(transaction4.date).to eq(Date.new(2019, 1, 1))
        expect(transaction4.date2).to eq(Date.new(2019, 1, 1))
        expect(transaction4.amount).to eq(1467.71)
        expect(transaction4.balance).to eq(1467.71)
        expect(transaction4.description).to eq("Initial transaction")
        expect(transaction4.category_id).to eq(3)
        expect(transaction4.transaction_id).to eq("jklm5647")

        [transaction1, transaction2, transaction3, transaction4].each do |transaction|
          first_transaction_account = transaction.account

          expect(first_transaction_account.class).to eq(AfterbanksPSD2::Account)
          expect(first_transaction_account.product).to eq("ES2720809591124344566256")
          expect(first_transaction_account.type).to eq("checking")
          expect(first_transaction_account.balance).to eq(1094.12)
          expect(first_transaction_account.countable_balance).to eq(1081.13)
          expect(first_transaction_account.arranged_balance).to eq(1143.71)
          expect(first_transaction_account.currency).to eq("EUR")
          expect(first_transaction_account.description).to eq("A checking account")
          expect(first_transaction_account.iban).to eq("ES2720809591124344566256")
          expect(first_transaction_account.is_owner).to be_truthy
          expect(first_transaction_account.holders).to eq(
            [
              { "role" => 'Admin', "name" => 'Mary', "id" => 1 },
              { "role" => 'Admin', "name" => 'Liz', "id" => 2 },
              { "role" => 'Supervisor', "name" => 'John', "id" => 3 }
            ]
          )
        end

        expect(transaction5.class).to eq(AfterbanksPSD2::Transaction)
        expect(transaction5.date).to eq(Date.new(2021, 4, 1))
        expect(transaction5.date2).to eq(Date.new(2021, 4, 1))
        expect(transaction5.amount).to eq(818.13)
        expect(transaction5.balance).to eq(818.13)
        expect(transaction5.description).to eq("Black sheep transaction")
        expect(transaction5.category_id).to eq(2)
        expect(transaction5.transaction_id).to eq("mnop1987")

        last_transaction_account = transaction5.account

        expect(last_transaction_account.class).to eq(AfterbanksPSD2::Account)
        expect(last_transaction_account.product).to eq("ES9231902434113168967688")
        expect(last_transaction_account.type).to eq("loan")
        expect(last_transaction_account.balance).to eq(-91.99)
        expect(last_transaction_account.countable_balance).to eq(-86.71)
        expect(last_transaction_account.arranged_balance).to eq(-99.13)
        expect(last_transaction_account.currency).to eq("USD")
        expect(last_transaction_account.description).to eq("A loan")
        expect(last_transaction_account.iban).to eq("ES9231902434113168967688")
        expect(last_transaction_account.is_owner).to be_falsey
        expect(last_transaction_account.holders).to eq(
          [
            { "role" => 'Admin', "name" => 'Sandy', "id" => 12 },
            { "role" => 'Supervisor', "name" => 'Joe', "id" => 34 }
          ]
        )
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

      context "which is T000 (generic, transactions variant)" do
        let(:error) { 'T000' }

        it "raises a GenericTransactionError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::GenericTransactionError)
              .and having_attributes(
                code:    'T000',
                message: "Error genérico con las transacciones"
              )
          )
        end
      end

      context "which is T001 (product mismatch with the consent, transactions variant)" do
        let(:error) { 'T001' }

        it "raises a InvalidConsentForProductError" do
          expect { api_call }.to raise_error(
            an_instance_of(AfterbanksPSD2::InvalidConsentForProductError)
              .and having_attributes(
                code:    'T001',
                message: "El consentimiento no ha sido creado para el producto solicitado"
              )
          )
        end
      end
    end

    context "when products is missing" do
      let(:products) { nil }

      it "raises an ArgumentError" do
        expect { api_call }.to raise_error(ArgumentError, "Products is missing")
      end
    end

    context "when products is not a string" do
      let(:products) { 123 }

      it "raises an ArgumentError" do
        expect { api_call }.to raise_error(ArgumentError, "Products must be a string")
      end
    end

    context "when produts it's an empty string" do
      let(:products) { '' }

      it "raises an ArgumentError" do
        expect { api_call }.to raise_error(ArgumentError, "Products is missing")
      end
    end

    context "when start_date is missing" do
      let(:start_date) { nil }

      it "raises an ArgumentError" do
        expect { api_call }.to raise_error(ArgumentError, "Start date is missing")
      end
    end

    context "when start_date is not a Date" do
      let(:start_date) { '2020-03-24' }

      it "raises an ArgumentError" do
        expect { api_call }.to raise_error(ArgumentError, "Start date must be a Date")
      end
    end
  end
end
