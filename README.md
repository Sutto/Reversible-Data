# ReversibleData #

ReversibleData makes it easy to define models / tables that
are automatically brought up and down as part of the testing
process. It doesn't use migrations instead simply creating
and dropping tables.

## Usage: ReversibleData::Table ##

To get started, you need to setup and require the gem and establish
a connection. For most plugins, the example should fill most uses.
    
    require 'reversible_data'
    
    ReversibleData.in_memory!
    
    table = ReversibleData.add(:users) do |t|
      t.string  :name
      t.integer :age
    end
    
    # Optional: a class_eval block
    
    table.define_model do
      validates_presence_of :name
    end
    
    # Reset the definition
    table.clear_model_definition!
    
    # You can then use table.create_table, table.drop_table,
    # table.create_model, table.remove_model.
    
Using ReversibleData.add, you can specify a second argument as a string
which will define the model / constant name. e.g:
      
    ReversibleData.add(:awesome_sauce, "Ninja")
    
If nil, it will use the rails default method of generating a model name.

Finally, it accepts an options hash with :skip\_model and :skip\_table
which make it easy to skip creating part.

## Usage: ReversibleData::TableManager ##

The table manager is a simple wrapper around multiple tables
which makes it super easy to do the up / down process. E.g.:

    manager = ReversibleData.manager_for(:users, :awesome_sauce)
    manager.up!
    manager.down!
    
## Shoulda Macro ##

Conveniently, there is a simple Shoulda macro you can use to make
make writing these tests easy. It's as simple as:

    class MyTest < Test::Unit::TestCase
      extend ReversibleData::ShouldaMacros
      
      with_tables :users, :awesome_sauce do
      
        # Your tests here...
      
      end
      
    end