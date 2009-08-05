require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'redgreen'
require 'reversible_data'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end