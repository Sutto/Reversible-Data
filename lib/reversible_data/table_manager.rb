module ReversibleData
  class TableManager
    
    def initialize(*names)
      @names = names.map { |n| n.to_sym }
    end
    
    def up!
      @names.each do |name|
        table.up! unless (table = table_for(name)).nil?
      end
    end
    
    def down!
      @names.each do |name|
        table.down! unless (table = table_for(name)).nil?
      end
    end
    
    protected
    
    def table_for(name)
      Table.known_models[name]
    end
    
  end
end