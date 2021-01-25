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
  end
end
