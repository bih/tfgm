Gem::Specification.new do |s|
  s.name        = 'tfgm'
  s.version     = '0.0.5'
  s.date        = '2013-03-26'
  s.summary     = 'A simple Ruby wrapper for the TFGM REST API.'
  s.description = <<-EOF
  A simple Ruby wrapper for the Transport for Greater Manchester REST API (i.e. bus routes, car parks, metrolinks).
  EOF
  s.authors     = ["Bilawal Hameed"]
  s.email       = 'b@bilawal.co.uk'
  s.files       = ["lib/tfgm.rb"]
  s.license     = 'MIT'
  s.homepage    = 'http://github.com/bih/tfgm'
  s.extra_rdoc_files = ['README.markdown']


  s.post_install_message = <<-EOF
-------------------
** NOTICE ** 
The REST API is currently unstable and not fit for production. This is due to the REST API, and not the Rubygem.
If you'd like to contribute to the development of the gem, visit http://github.com/bih/tfgm
-------------------
  EOF
  
  ## Requirements
  s.add_runtime_dependency 'curb'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'active_support'
end