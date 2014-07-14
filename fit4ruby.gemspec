GEM_SPEC = Gem::Specification.new do |s|
  s.name        = 'fit4ruby'
  s.version     = '0.0.1'
  s.licenses    = ['GNU GPL version 2']
  s.summary     = 'Library to read GARMIN FIT files.'
  s.description = <<EOT
This library can read GARMIN FIT files and convert them into a Ruby data
structure for easy processing.
EOT
  s.authors     = [ 'Chris Schlaeger' ]
  s.email       = 'chris@linux.com'
  s.files       = (`git ls-files -- lit`).split("\n")
  s.homepage    = 'https://rubygems.org/gems/fit4ruby'

  s.add_dependency('bindata', '>=2.0.0')
  s.add_development_dependency('yard')
end
