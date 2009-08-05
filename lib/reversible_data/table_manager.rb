module ReversibleData
  class TableManager
    
    def initialize(*names)
      @names = names.map { |n| n.to_s.tableize.to_sym }
    end
    
    def up!
      @names.each do |name|
        unless (table = table_for(name)).nil?
          table.create_table
          table.create_model
        end
      end
    end
    
    def down!
      @names.each do |name|
        unless (table = table_for(name)).nil?
          table.drop_table
          table.remove_model
        end
      end
    end
    
    protected
    
    def table_for(name)
      Table.known_models[name.to_sym]
    end
    
  end
end