# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{reversible_data}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darcy Laycock"]
  s.date = %q{2009-09-12}
  s.email = %q{sutto@sutto.net}
  s.files = ["lib/reversible_data", "lib/reversible_data/shoulda_macros.rb", "lib/reversible_data/table.rb", "lib/reversible_data/table_manager.rb", "lib/reversible_data.rb", "test/reversible_data_test.rb", "test/table_manager_test.rb", "test/table_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://sutto.net/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Reversible Data provides migration-like functionality for tests etc - All with temporary models.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
