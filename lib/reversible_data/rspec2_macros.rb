module ReversibleData
  module RSpec2Macros

    def use_reversible_tables(*tables)
      options       = tables.extract_options!
      scope         = options.fetch(:scope, :each)
      table_manager = ReversibleData.manager_for(*tables)
      before(scope) { table_manager.up! }
      after(scope)  { table_manager.down! }
    end

  end
end