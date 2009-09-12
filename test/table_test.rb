require 'test_helper'

class TableTest < Test::Unit::TestCase
  context '' do
    
    setup    { ReversibleData.in_memory! }
  
    teardown { ReversibleData.remove_all }
  
    should 'automatically add it to a list of known models' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      assert_equal table, ReversibleData::Table.known_models[:user]
    end
  
    should 'default the table name' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      assert_equal "users", table.table_name
      table = ReversibleData::Table.new(:users) { |t| t.string :name }
      assert_equal "users", table.table_name
    end
  
    should 'default the model class name' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      assert_equal "User", table.model_name
      table = ReversibleData::Table.new(:users) { |t| t.string :name }
      assert_equal "User", table.model_name
    end
  
    should 'let you override the table name' do
      table = ReversibleData::Table.new(:user, :table_name => "awesomesauce") { |t| t.string :name }
      assert_equal "awesomesauce", table.table_name
    end
  
    should 'let you override the model class name' do
      table = ReversibleData::Table.new(:user, :class_name => "Ninja") { |t| t.string :name }
      assert_equal "Ninja", table.model_name
    end
  
    should 'let you skip creating the model' do
      table = ReversibleData::Table.new(:user, :skip_model => true) { |t| t.string :name }
      table.create_model
      assert !defined?(User)
    end
  
    should 'let you skip creating the table' do
      table = ReversibleData::Table.new(:user, :skip_table => true) { |t| t.string :name }
      table.create_table
      assert !ActiveRecord::Base.connection.table_exists?(:users)
    end
  
    should 'let you create the table' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.create_table
      assert ActiveRecord::Base.connection.table_exists?(:users)
    end
  
    should 'let you drop the table' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.create_table
      table.drop_table
      assert !ActiveRecord::Base.connection.table_exists?(:users)
    end
  
    should 'let you create the model' do
      assert !defined?(::User)
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.create_model
      assert defined?(::User)
    end
  
    should 'let you remove the model' do
      assert !defined?(::User)
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.create_model
      table.remove_model
      assert !defined?(::User)
    end
    
    should 'let you call up! to create the table and the model' do
      assert !defined?(::User)
      assert !ActiveRecord::Base.connection.table_exists?(:users)
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.up!
      assert defined?(::User)
      assert ActiveRecord::Base.connection.table_exists?(:users)
      assert User < ActiveRecord::Base
    end
    
    should 'let you call down! to clean up' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.up!
      assert ActiveRecord::Base.connection.table_exists?(:users)
      assert User < ActiveRecord::Base
      table.down!
      assert !ActiveRecord::Base.connection.table_exists?(:users)
      assert !defined?(::User)
    end
  
    should 'default to skipping model if the constant exists' do
      ::Awesome = true
      table = ReversibleData::Table.new(:awesome)
      assert table.skip_model?
      Object.send(:remove_const, :Awesome)
    end
  
    should 'default to skipping the table if connected and the table exists' do
      ActiveRecord::Base.connection.create_table(:ninjas) { |t| t.string :name }
      table = ReversibleData::Table.new(:ninja)
      assert table.skip_table?
      ActiveRecord::Base.connection.drop_table(:ninjas)
    end
  
    should 'let you define a model block' do
      table = ReversibleData::Table.new(:ninja)
      table.define_model do
        cattr_accessor :ninjariffic
        self.ninjariffic = "felafel"
      end
      table.create_model
      assert Ninja.respond_to?(:ninjariffic)
      assert Ninja.respond_to?(:ninjariffic=)
      assert_equal "felafel", Ninja.ninjariffic
      table.remove_model
    end
  
    should 'let not call the blueprint if none is specified' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.up!
      assert !User.blueprint_called
    end
    
    should 'call the blueprint if present' do
      table = ReversibleData::Table.new(:user) { |t| t.string :name }
      table.blueprint {}
      table.up!
      assert User.blueprint_called
    end
  
  end
end