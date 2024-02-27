# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'travis/amqp/version'

Gem::Specification.new do |s|
  s.name          = 'travis-amqp'
  s.version       = Travis::Amqp::VERSION
  s.authors       = ['Travis CI']
  s.email         = 'contact@travis-ci.org'
  s.homepage      = 'https://github.com/travis-ci/travis-amqp'
  s.summary       = 'AMQP support for Travis CI'
  s.description   = "#{s.summary}."

  s.files         = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.required_ruby_version = '~> 3.2'
end
