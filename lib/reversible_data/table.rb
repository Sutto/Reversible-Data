module ReversibleData
  class Table
    
    cattr_accessor :known_models
    self.known_models = {}
    
    attr_accessor :name, :table_name, :model_name, :options
    
    def initialize(name, opts = {}, &blk)
      @name             = name.to_s.underscore.to_sym
      @table_name       = (opts[:table_name] || @name.to_s.tableize).to_s
      @model_name       = (opts[:class_name] || @name.to_s.classify).to_s
      @migrator         = blk
      @model_definition = nil
      default_options   = {:skip_model => Object.const_defined?(@model_name),
                           :skip_table => (connected? && connection.table_exists?(@table_name))}
      @options          = opts.reverse_merge(default_options)
      @blueprint        = nil
      self.known_models[@name] = self
    end
    
    def skip_model?
      !!@options[:skip_model]
    end
    
    def skip_table?
      !!@options[:skip_table]
    end
    
    def up!
      create_table
      create_model
    end
    
    def down!
      remove_model
      drop_table
    end
    
    def drop_table
      return if skip_table? || !connected?
      connection.drop_table(@table_name) if connection.table_exists?(@table_name)
    end
    
    def create_table(autodrop = true)
      return if skip_table? || !connected?
      drop_table if autodrop
      return if connection.table_exists?(@table_name)
      connection.create_table(table_name, &@migrator)
    end
    
    def remove_model
      return if skip_model?
      if Object.const_defined?(@model_name)
        silence_warnings { Object.send(:remove_const, @model_name) }
      end
    end
    
    def create_model(autoremove = true)
      return if skip_model?
      remove_model if autoremove
      return if Object.const_defined?(@model_name)
      @model = Class.new(ActiveRecord::Base)
      @model.class_eval(&@model_definition) unless @model_definition.nil?
      @model.blueprint(&@blueprint) unless @blueprint.nil? || !@model.respond_to?(:blueprint)
      Object.const_set(@model_name, @model)
    end
    
    def define_model(&blk)
      @model_definition = blk unless blk.nil?
    end
    
    def blueprint(&blk)
      @blueprint = blk unless blk.nil?
    end
    
    def clear_model_definition!
      @model_definition = nil
    end
    
    def destroy
      self.known_models.delete(@name)
    end
    
    protected
    
    def connection
      ActiveRecord::Base.connection
    end
    
    def connected?
      ReversibleData.connected?
    end
    
  end
end