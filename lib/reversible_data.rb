$:.unshift File.dirname(__FILE__)

require 'active_support'
require 'active_record'

module ReversibleData
  
  autoload :Table,         'reversible_data/table'
  autoload :TableManager,  'reversible_data/table_manager'
  autoload :ShouldaMacros, 'reversible_data/shoulda_macros'
  
  def self.add(name, opts = {}, &blk)
    Table.new(name, opts, &blk)
  end
  
  def self.[](name)
    Table.known_models[name]
  end
  
  def self.manager_for(*tables)
    TableManager.new(*tables)
  end
  
  def self.in_memory!
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
  end
  
end