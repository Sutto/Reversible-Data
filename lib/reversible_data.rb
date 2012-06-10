$:.unshift File.dirname(__FILE__)

require 'active_support'
require 'active_record'

module ReversibleData
  
  autoload :Table,         'reversible_data/table'
  autoload :TableManager,  'reversible_data/table_manager'
  autoload :ShouldaMacros, 'reversible_data/shoulda_macros'
  autoload :RSpec2Macros,  'reversible_data/rspec2_macros'
  
  def self.add(name, opts = {}, &blk)
    Table.new(name, opts, &blk)
  end
  
  def self.[](name)
    Table.known_models[name]
  end
  
  def self.remove(name)
    table = self[name]
    table.down!
    table.destroy
  end
  
  def self.remove_all
    Table.known_models.each_value do |t|
      t.down!
      t.destroy
    end
  end
  
  def self.manager_for(*tables)
    TableManager.new(*tables)
  end
  
  def self.in_memory!
    if connected?
      ActiveRecord::Base.connection.disconnect!
      ActiveRecord::Base.remove_connection
    end
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
  end
  
  def self.connected?
    ActiveRecord::Base.connection.active?
  rescue ActiveRecord::ConnectionNotEstablished
    false
  end
  
end