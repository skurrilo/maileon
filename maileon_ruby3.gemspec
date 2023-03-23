# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maileon_ruby3/version'

Gem::Specification.new do |spec|
  spec.name          = "maileon_ruby3"
  spec.version       = MaileonRuby3::VERSION
  spec.authors       = ["Ain Tohvri", "Florian Jäckel"]
  spec.email         = ["at@interactive-pioneers.de", "mail@florianjaeckel.de"]
  spec.summary       = %q{Ruby v3 wrapper for Maileon API.}
  spec.description   = %q{Ruby v3 wrapper for Maileon email marketing software API.}
  spec.homepage      = "https://github.com/skurrilo/maileon"
  spec.license       = "GPL-3.0"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "excon", "~> 0.99.0"
  spec.add_runtime_dependency "json", "~> 2.6.0"
  spec.add_runtime_dependency "rails", "~> 7.0"
  spec.add_runtime_dependency "nokogiri"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "sinatra"
end
