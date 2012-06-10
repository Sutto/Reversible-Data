# ReversibleData

ReversibleData makes it easy to define models / tables that
are automatically brought up and down as part of the testing
process. It doesn't use migrations instead simply creating
and dropping tables.


## Installation

Is simple, simply add:

```ruby
gem 'reversible_data', '~> 1.0'
```

To your Gemfile and run bundle install.

Inside your test setup, use the below examples on how to declare tables.
Finally, also check for our example Shoulda and Rspec examples.

## Creating and Managing Models and Tables with ReversibleData::Table

To get started, you need to setup and require the gem and establish
a connection. For most plugins, the example should fill most uses.

```ruby    
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
```
  
Using ReversibleData.add, you can specify a `:class_name` option
      
```ruby
ReversibleData.add(:awesome_sauce, :class_name => "Ninja")
```
    
If nil, it will use the rails default method of generating a model name.

Finally, it accepts an options hash with `:skip_model` and `:skip_table`
which make it easy to skip creating part.

## ReversibleData::TableManager

The table manager is a simple wrapper around multiple tables
which makes it super easy to do the up / down process. E.g.:

```ruby
manager = ReversibleData.manager_for(:users, :awesome_sauce)
manager.up!
manager.down!
```

## Test Suite Integration

### RSpec2 Macro

To make it easy to integrate with RSpec2-based test suites (e.g. [Rocket Pants](https://github.com/filtersquad.com/rocket_pants) uses
it in it's integration tests), we provide helpers:

In your `spec_helper.rb`, First add:

```ruby
config.extend ReversibleData::RSpec2Macros
```

Inside your `RSpec.configure` block. Next, In your tests:

```ruby

describe "Something" do

  context 'with a model' do
    use_reversible_tables :user

    it 'should be awesome' do
      User.count.should == 42 # Will always fail.
    end

  end

end

```

Finally, note the `use_reversible_tables` method accepts options, the only current one being `:scope`, which lets you specify the
setup / teardown scope, defaulting to `:each` but changeable to `:all` (e.g. in RocketPants).
    
### Shoulda Macro

Conveniently, there is a simple Shoulda macro you can use to make
make writing these tests easy. It's as simple as:

```ruby
class MyTest < Test::Unit::TestCase
  extend ReversibleData::ShouldaMacros
  
  with_tables :users, :awesome_sauce do
  
    # Your tests here...
  
  end
  
end
```