# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'see_as_vee/version'

Gem::Specification.new do |spec|
  spec.name          = 'see_as_vee'
  spec.version       = SeeAsVee::VERSION
  spec.authors       = ['Aleksei Matiushkin']
  spec.email         = ['aleksei.matiushkin@kantox.com']

  spec.summary       = 'Really easy CSV/XLSX reader/writer.'
  spec.description   = 'Load CSV/XLSX, check it, format it and spit it back to the user with a single command.'
  spec.homepage      = 'https://kantox.com'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # TODO: Newer versions cause issues with the included extension
  #
  # superclass mismatch for class Loader
  #
  spec.add_dependency 'simple_xlsx_reader', '~> 1.0.5'
  spec.add_dependency 'caxlsx', '~> 3.4.1'
  # spec.add_dependency 'ruby-filemagic', require: false

  spec.add_development_dependency 'bundler', '> 2.3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
  # TODO: There are some issues with dry gems versions for some ruby versions
  # and specs failing
  # This needs to updated and sanitized
  spec.add_development_dependency 'dry-validation', '~> 0.13.3'
  spec.add_development_dependency 'dry-configurable', '~> 0.11.6'

  # spec.add_development_dependency 'codeclimate-test-reporter'
  # spec.add_development_dependency 'simplecov', '~> 0.12.0'
end
