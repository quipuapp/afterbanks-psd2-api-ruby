# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'afterbanks_psd2/version'

Gem::Specification.new do |spec|
  spec.name          = 'afterbanks-psd2-api-ruby'
  spec.version       = AfterbanksPSD2::VERSION
  spec.authors       = ['Florent Lemaitre']
  spec.email         = ['flemaitre@sellsy.com']

  spec.summary       = "Ruby client for the Afterbanks' PSD2 API"
  spec.homepage      = 'https://getquipu.com'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', '~> 2.0.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
