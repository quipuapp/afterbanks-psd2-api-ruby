require "spec_helper"

describe AfterbanksPSD2::User do
  describe "#get" do
    before do
      stub_request(:post, "https://apipsd2.afterbanks.com/me/")
        .with(
          body: {
            servicekey: 'a_servicekey_which_works'
          }
        )
        .to_return(
          status:  200,
          body:    response_json(resource: 'user', action: 'get'),
          headers: { debug_id: 'usrget1234' }
        )
    end

    it "works" do
      response = AfterbanksPSD2::User.get

      expect(response.class).to eq(AfterbanksPSD2::Response)
      expect(response.body).to match_array(
        {
          "limit"=>1234391245,
          "counter"=>912,
          "remaining_calls"=>1234390333,
          "date_renewal"=>"01-04-2020",
          "detail"=>nil
        }
      )
      expect(response.debug_id).to eq('usrget1234')

      user = response.result

      expect(user.class).to eq(AfterbanksPSD2::User)
      expect(user.limit).to eq(1234391245)
      expect(user.counter).to eq(912)
      expect(user.remaining_calls).to eq(1234390333)
      expect(user.date_renewal).to eq(Date.new(2020, 4, 1))
      expect(user.detail).to be_nil
    end
  end

  describe "serialization" do
    let(:limit) { 1234391245 }
    let(:counter) { 912 }
    let(:remaining_calls) { 1234390333 }
    let(:date_renewal) { Date.new(2020, 4, 16) }
    let(:detail) { nil }

    let(:original_user) do
      AfterbanksPSD2::User.new(
        limit:           limit,
        counter:         counter,
        remaining_calls: remaining_calls,
        date_renewal:    date_renewal,
        detail:          detail
      )
    end

    it "works" do
      serialized_user = Marshal.dump(original_user)
      recovered_user = Marshal.load(serialized_user)

      expect(recovered_user.class).to eq(AfterbanksPSD2::User)
      expect(recovered_user.limit).to eq(limit)
      expect(recovered_user.counter).to eq(counter)
      expect(recovered_user.remaining_calls).to eq(remaining_calls)
      expect(recovered_user.date_renewal).to eq(date_renewal)
      expect(recovered_user.detail).to be_nil
    end
  end
end
