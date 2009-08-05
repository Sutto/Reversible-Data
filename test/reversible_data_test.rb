require 'test_helper'

class ReversibleDataTest < Test::Unit::TestCase
  
  should 'have add as a shortcut to Table.new' do
    mock(ReversibleData::Table).new(:awesome, {})
    ReversibleData.add(:awesome)
    mock(ReversibleData::Table).new(:rocket, :table_name => "awesomesauces")
    ReversibleData.add(:rocket, :table_name => "awesomesauces")
  end
  
  should 'have [] as a shortcut to find' do
    mock(ReversibleData::Table.known_models)[:awesome]
    ReversibleData[:awesome]
  end
  
  should 'have remove to remove a specific table' do
    ReversibleData.add(:awesome) { |t| t.string :name }
    assert !ReversibleData[:awesome].nil?
    ReversibleData.remove(:awesome)
    assert ReversibleData[:awesome].nil?
  end
  
  should 'let you remove all definitions with remove_all' do
    ReversibleData.add(:awesome) { |t| t.string :name }
    ReversibleData.add(:ninjas)  { |t| t.string :name }
    assert !ReversibleData[:awesome].nil?
    assert !ReversibleData[:ninjas].nil?
    ReversibleData.remove_all
    assert ReversibleData[:awesome].nil?
    assert ReversibleData[:ninjas].nil?
  end
  
  should 'let you create a Table Manager with manager_for' do
    ReversibleData.add(:awesome) { |t| t.string :name }
    ReversibleData.add(:ninjas)  { |t| t.string :name }
    mock(ReversibleData::TableManager).new(:awesome, :ninjas)
    ReversibleData.manager_for(:awesome, :ninjas)
  end
  
  should 'let you establish an in-memory connection' do
    assert !ReversibleData.connected?
    ReversibleData.in_memory!
    assert ReversibleData.connected?
  end
  
end