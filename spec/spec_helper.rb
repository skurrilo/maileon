require 'pry'
require 'maileon_ruby3'
#require 'webmock/rspec'
require 'support/mock_maileon'

# Do not allow external calls to API
#WebMock.disable_net_connect!(allow_localhost: true)

# Stub all external API calls for WebMock
RSpec.configure do |config|
  config.before(:each) do
    #    stub_request(:any, /api.maileon.com/).to_rack(MockMaileonRuby3)
  end
end