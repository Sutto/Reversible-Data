module ReversibleData
  class Table
    
    cattr_accessor :known_models
    self.known_models = {}
    
    attr_accessor :table_name, :model_name, :options
    
    def initialize(table_name, opts = {}, &blk)
      @table_name       = table_name.to_s.tableize.to_sym
      @model_name       = (opts[:class_name] || @table_name).to_s.classify
      @migrator         = blk
      @model_definition = nil
      default_options   = {:skip_model => Object.const_defined?(@model_name), :skip_table => connection.table_exists?(@table_name)}
      @options          = opts.reverse_merge(default_options)
      @blueprint        = nil
      self.known_models[table_name.to_sym] = self
    end
    
    def drop_table
      return if @options[:skip_table]
      connection.drop_table(@table_name) if connection.table_exists?(@table_name)
    end
    
    def create_table(autodrop = true)
      return if @options[:skip_table]
      drop_table if autodrop
      return if connection.table_exists?(@table_name)
      connection.create_table(table_name, &@migrator)
    end
    
    def remove_model
      return if @options[:skip_model]
      if Object.const_defined?(@model_name)
        silence_warnings { Object.send(:remove_const, @model_name) }
      end
    end
    
    def create_model(autoremove = true)
      return if @options[:skip_model]
      remove_model if autoremove
      return if Object.const_defined?(@model_name)
      @model = Class.new(ActiveRecord::Base)
      @model.class_eval(&@model_definition) unless @model_definition.nil?
      @model.blueprint(&@blueprint) unless @blueprint.nil?
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
      self.known_models[@table_name] = nil
    end
    
    protected
    
    def connection
      ActiveRecord::Base.connection
    end
    
  end
end