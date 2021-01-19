$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'webmock/rspec'
require "afterbanks_psd2"
require "timecop"

def response_json(resource:, action:)
  path = File.join('spec', 'responses', resource, "#{action}.json")
  File.read(path)
end

AfterbanksPSD2.configure do |config|
  config.servicekey = 'a_servicekey_which_works'
end

WebMock.disable_net_connect!
