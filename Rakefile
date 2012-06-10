require 'rake'
require 'rake/testtask'
require 'bundler/gem_tasks'

task :default => "test:units"

namespace :test do
  
  desc "Runs the unit tests for perennial"
  Rake::TestTask.new("units") do |t|
    t.pattern = 'test/*_test.rb'
    t.libs << 'test'
    t.verbose = true
  end
  
end

task :gemspec do
  require 'rubygems'
  spec = Gem::Specification.new do |s|
    s.name     = 'reversible_data'
    s.email    = 'sutto@sutto.net'
    s.homepage = 'http://sutto.net/'
    s.authors  = ["Darcy Laycock"]
    s.version  = "0.1.0"
    s.summary  = "Reversible Data provides migration-like functionality for tests etc - All with temporary models."
    s.files    = FileList["{lib,test}/**/*"].to_a
    s.platform = Gem::Platform::RUBY
  end
  File.open("reversible_data.gemspec", "w+") { |f| f.puts spec.to_ruby }
end
