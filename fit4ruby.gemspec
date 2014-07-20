# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fit4ruby/version'

GEM_SPEC = Gem::Specification.new do |s|
  s.name         = 'fit4ruby'
  s.version      = Fit4Ruby::VERSION
  s.license      = 'GNU GPL version 2'
  s.summary      = 'Library to read GARMIN FIT files.'
  s.description  = <<EOT
This library can read and write FIT files and convert them into a Ruby data
structure for easy processing. This library was written for the Garmin FR620.
Fit files from other devices may or may not work.
EOT
  s.authors      = [ 'Chris Schlaeger' ]
  s.email        = 'chris@linux.com'
  s.homepage     = 'https://github.com/scrapper/fit4ruby'

  s.files        = (`git ls-files -- lit`).split("\n")
  s.test_files   = s.files.grep('test/')
  s.require_path = [ 'lib' ]
  s.required_ruby_version = '>=2.0'

  s.add_dependency('bindata', '>=2.0.0')
  s.add_development_dependency('yard')
  s.add_development_dependency('rake')
  s.add_development_dependency('bundler', ">=1.6.4")
end
