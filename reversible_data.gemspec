# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name     = 'reversible_data'
  s.email    = 'sutto@sutto.net'
  s.homepage = 'http://sutto.net/'
  s.authors  = ["Darcy Laycock"]
  s.version  = "1.0.0"
  s.summary  = "Reversible Data provides migration-like functionality for tests etc - All with temporary models."
  s.files    = Dir["{lib,test}/**/*"].to_a
  s.platform = Gem::Platform::RUBY

  s.add_dependency 'activerecord'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'sqlite3'

end