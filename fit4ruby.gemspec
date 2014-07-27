# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fit4ruby/version'

GEM_SPEC = Gem::Specification.new do |spec|
  spec.name         = 'fit4ruby'
  spec.version      = Fit4Ruby::VERSION
  spec.license      = 'GNU GPL version 2'
  spec.summary      = 'Library to read GARMIN FIT files.'
  spec.description  = <<EOT
This library can read and write FIT files and convert them into a Ruby data
structure for easy processing. This library was written for the Garmin FR620.
Fit files from other devices may or may not work.
EOT
  spec.authors      = [ 'Chris Schlaeger' ]
  spec.email        = 'chris@linux.com'
  spec.homepage     = 'https://github.com/scrapper/fit4ruby'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>=2.0'

  spec.add_dependency('bindata', '>=2.0.0')
  spec.add_development_dependency('yard')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('bundler', ">=1.6.4")
end
