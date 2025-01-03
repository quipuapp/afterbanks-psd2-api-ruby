require "spec_helper"

describe AfterbanksPSD2 do
  let(:test_api_url) {  'https://test.apipsd2.afterbanks.com' }

  before do
    ENV['AFTERBANKS_API_URL'] = test_api_url
  end

  describe "#configuration" do
    it "returns a Configuration instance which has an API key and a logger" do
      configuration = subject.configuration

      expect(configuration).to be_a(AfterbanksPSD2::Configuration)
      expect(configuration).to respond_to(:servicekey)
      expect(configuration).to respond_to(:logger)
    end
  end

  describe "#configure" do
    it "returns the servicekey properly" do
      expect(subject.configuration.servicekey).to eq('a_servicekey_which_works')
    end
  end

  describe "#api_call" do
    let(:path) { '/PSD2/some/endpoint' }
    let(:params) { { a: :b, c: :d, e: :f } }
    let(:api_call) {
      subject.api_call(method: method, path: path, params: params)
    }

    context "for a GET request" do
      let(:method) { :get }

      before do
        stub_request(:get, "#{test_api_url}/PSD2/some/endpoint?a=b&c=d&e=f")
          .to_return(
            status:  200,
            body:    "{}",
            headers: { debug_id: 'abcd' }
          )
      end

      it "works" do
        expect(subject)
          .to receive(:log_request)
                .with(
                  method:   :get,
                  url:      "#{test_api_url}/PSD2/some/endpoint",
                  params:   { a: :b, c: :d, e: :f },
                  debug_id: 'abcd'
                )

        expect(RestClient::Request)
          .to receive(:execute)
                .with(
                  method:  :get,
                  url:     "#{test_api_url}/PSD2/some/endpoint",
                  headers: {
                    params: { a: :b, c: :d, e: :f }
                  }
                )
                .and_call_original

        api_call
      end

      context "with timeout option" do
        let(:api_call) {
          subject.api_call(
            method:  method, path: path, params: params, options: { timeout: 10 }
          )
        }

        it "works" do
          expect(RestClient::Request)
            .to receive(:execute)
                  .with(
                    method:  :get,
                    url:     "#{test_api_url}/PSD2/some/endpoint",
                    headers: {
                      params: { a: :b, c: :d, e: :f }
                    },
                    timeout: 10
                  )
                  .and_call_original

          api_call
        end
      end

      context "with null options" do
        let(:api_call) {
          subject.api_call(
            method: method, path: path, params: params, options: nil
          )
        }

        it "works" do
          expect(RestClient::Request)
            .to receive(:execute)
                  .with(
                    method:  :get,
                    url:     "#{test_api_url}/PSD2/some/endpoint",
                    headers: {
                      params: { a: :b, c: :d, e: :f }
                    }
                  )
                  .and_call_original

          api_call
        end
      end

      context 'when the server return a timeout error' do
        before do
          allow(RestClient::Request)
            .to receive(:execute) { raise RestClient::Exceptions::ReadTimeout }
        end

        it 'logs the request and raises the error' do
          expect(subject)
            .to receive(:log_request)
                  .with(
                    method: :get,
                    url:    "#{test_api_url}/PSD2/some/endpoint",
                    params: { a: :b, c: :d, e: :f }
                  )

          expect { api_call }
            .to raise_error(RestClient::Exceptions::ReadTimeout)
        end
      end
    end

    context "for a POST request" do
      let(:method) { :post }

      before do
        stub_request(:post, "#{test_api_url}/PSD2/some/endpoint")
          .with(
            body: {
              "a" => "b",
              "c" => "d",
              "e" => "f"
            }
          )
          .to_return(
            status:  200,
            body:    "{}",
            headers: { debug_id: 'abcd' }
          )
      end

      it "works" do
        expect(subject)
          .to receive(:log_request)
                .with(
                  method:   :post,
                  url:      "#{test_api_url}/PSD2/some/endpoint",
                  params:   { a: :b, c: :d, e: :f },
                  debug_id: 'abcd'
                )

        expect(RestClient::Request)
          .to receive(:execute)
                .with(
                  method:  :post,
                  url:     "#{test_api_url}/PSD2/some/endpoint",
                  payload: { :a => :b, :c => :d, :e => :f }
                )
                .and_call_original

        api_call
      end

      context "with timeout option" do
        let(:api_call) {
          subject.api_call(
            method:  method, path: path, params: params, options: { timeout: 10 }
          )
        }

        it "works" do
          expect(RestClient::Request)
            .to receive(:execute)
                  .with(
                    method:  :post,
                    url:     "#{test_api_url}/PSD2/some/endpoint",
                    payload: { :a => :b, :c => :d, :e => :f },
                    timeout: 10
                  )
                  .and_call_original

          api_call
        end
      end
    end
  end

  describe "#log_request" do
    before do
      Timecop.freeze(Time.new(2020, 3, 24, 18, 47))
    end

    let(:method) { :get }
    let(:url) { "https://some.where/over/the/rainbow" }
    let(:params) {
      {
        servicekey: 'secret_stuff',
        a:          :z,
        b:          :c,
        code:       'ruby',
        d:          :e
      }
    }
    let(:debug_id) { 'abcd' }
    let(:log_request) {
      subject.log_request(
        method:   method,
        url:      url,
        params:   params,
        debug_id: debug_id
      )
    }

    context "with a nil Afterbanks.configuration.logger" do
      before do
        allow(AfterbanksPSD2).to receive_message_chain(:configuration, :logger) {
          nil
        }
      end

      it "does not call the logger" do
        expect_any_instance_of(Logger).not_to receive(:info)

        log_request
      end
    end

    context "with a set-up logger" do
      before do
        logger = double(Logger)
        allow(logger).to receive(:info)

        allow(AfterbanksPSD2).to receive_message_chain(:configuration, :logger) {
          logger
        }
      end

      it "calls the logger with the proper info" do
        expect(AfterbanksPSD2.configuration.logger)
          .to receive(:info)
                .with(
                  {
                    message:   'Afterbanks PSD2 request',
                    method:    'GET',
                    url:       'https://some.where/over/the/rainbow',
                    time:      "2020-03-24 18:47:00 +0100",
                    timestamp: 1585072020,
                    debug_id:  'abcd',
                    params:    {
                      servicekey: '<masked>',
                      a:          'z',
                      b:          'c',
                      code:       'ruby',
                      d:          'e'
                    }
                  }
                )
                .once

        log_request
      end

      context "without params" do
        let(:params) { {} }

        it "calls the logger with the proper info" do
          expect(AfterbanksPSD2.configuration.logger)
            .to receive(:info)
                  .with(
                    {
                      message:   'Afterbanks PSD2 request',
                      method:    'GET',
                      url:       'https://some.where/over/the/rainbow',
                      time:      "2020-03-24 18:47:00 +0100",
                      timestamp: 1585072020,
                      debug_id:  'abcd',
                      params:    {}
                    }
                  )
                  .once

          log_request
        end
      end

      context "without debug_id" do
        let(:debug_id) { nil }

        it "calls the logger with the proper info" do
          expect(AfterbanksPSD2.configuration.logger)
            .to receive(:info)
                  .with(
                    {
                      message:   'Afterbanks PSD2 request',
                      method:    'GET',
                      url:       'https://some.where/over/the/rainbow',
                      time:      "2020-03-24 18:47:00 +0100",
                      timestamp: 1585072020,
                      debug_id:  'none',
                      params:    {
                        servicekey: '<masked>',
                        a:          'z',
                        b:          'c',
                        code:       'ruby',
                        d:          'e'
                      }
                    }
                  )
                  .once

          log_request
        end
      end

      after do
        Timecop.return
      end
    end
  end

  after do
    ENV['AFTERBANKS_API_URL'] = nil
  end
end
