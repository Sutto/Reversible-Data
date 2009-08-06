require 'test_helper'

class TableManagerTest < Test::Unit::TestCase
  context 'table managers in general' do
    
    setup do
      @table_a = ReversibleData.add(:a) { |t| t.string :name }
      @table_b = ReversibleData.add(:b) { |t| t.string :name }
      @table_c = ReversibleData.add(:c) { |t| t.string :name }
      @manager = ReversibleData::TableManager.new(:a, :b, :c)
    end
  
    should 'let you create a manager for a set of tables' do
      assert_equal [:a, :b, :c], @manager.managed_tables
    end
  
    should 'let you run up! on all managed tables' do
      [@table_a, @table_b, @table_c].each { |t| mock(t).up! }
      @manager.up!
    end
  
    should 'let you run down! on all managed tables' do
      [@table_a, @table_b, @table_c].each { |t| mock(t).down! }
      @manager.down!
    end
    
  end
end