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
  end
end
