module ReversibleData
  class TableManager
    
    attr_reader :managed_tables
    
    def initialize(*managed_tables)
      @managed_tables = managed_tables.map { |n| n.to_sym }.freeze
    end
    
    def up!
      @managed_tables.each do |name|
        table = table_for(name)
        table.up! unless table.nil?
      end
    end
    
    def down!
      @managed_tables.each do |name|
        table = table_for(name)
        table.down! unless table.nil?
      end
    end
    
    protected
    
    def table_for(name)
      Table.known_models[name]
    end
    
  end
end