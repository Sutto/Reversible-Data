require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'redgreen'
require 'reversible_data'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

module MockBlueprints
  
  def blueprint(&blk)
    # Use this as a kind of hacky way to ensure it is called.
    self.blueprint_called = true
  end
  
end

ActiveRecord::Base.class_eval do
  class_inheritable_accessor :blueprint_called
  self.blueprint_called = false
  extend MockBlueprints
end