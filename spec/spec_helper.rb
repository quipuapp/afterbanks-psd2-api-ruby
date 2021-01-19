$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'webmock/rspec'
require "afterbanks_psd2"

def response_json(resource:, action:)
  path = File.join('spec', 'responses', resource, "#{action}.json")
  File.read(path)
end

WebMock.disable_net_connect!
