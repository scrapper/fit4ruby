# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fit4ruby/version'

GEM_SPEC = Gem::Specification.new do |spec|
  spec.name         = 'fit4ruby'
  spec.version      = Fit4Ruby::VERSION
  spec.license      = 'GNU GPL version 2'
  spec.summary      = 'Library to read and write GARMIN FIT files.'
  spec.description  = <<EOT
This library can read and write FIT files and convert them into a Ruby data
structure for easy processing. This library was written for Garmin devices
like the FR620, Fenix 3, Fenix 3 HR, Fenix 5 (s and X). Fit files from other
devices may work as well but have not been tested.
EOT
  spec.authors      = [ 'Chris Schlaeger' ]
  spec.email        = 'chris@linux.com'
  spec.homepage     = 'https://github.com/scrapper/fit4ruby'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>=2.0'

  spec.add_dependency('bindata', '~>2.4.8')
  spec.add_development_dependency('yard', '~>0.9.20')
  spec.add_development_dependency('rake', '~>12.3.3')
  spec.add_development_dependency('bundler', '>=1.6.4')
  spec.add_development_dependency('rspec', '>=3.8')
  spec.add_development_dependency('pry', '>=0.12')
end
