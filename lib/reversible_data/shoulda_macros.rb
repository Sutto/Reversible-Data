module ReversibleData
  module ShouldaMacros
    
    def with_tables(*args, &blk)
      table_manager = ReversibleData.manager_for(*args)
      context '' do
        setup { table_manager.up! }
        context('', &blk)
        teardown { table_manager.down! }
      end
    end
    
  end
end