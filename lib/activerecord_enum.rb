require 'active_record'
require 'active_record/connection_adapters/mysql2_adapter'
require 'active_record/connection_adapters/abstract/schema_definitions.rb'

module ActiverecordEnum
end

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter < AbstractAdapter
      def native_database_types_with_enum
        native_database_types_without_enum.merge( :enum => { :name => "enum" } )
      end
      alias_method :native_database_types_without_enum, :native_database_types
      alias_method :native_database_types, :native_database_types_with_enum

      def type_to_sql_with_enum type, limit=nil, *args
        if type.to_s == "enum"
          "enum(#{limit.to_a.map{|n| "'#{n}'"}.join(",")})"
        else
          type_to_sql_without_enum type, limit, *args
        end
      end
      alias_method :type_to_sql_without_enum, :type_to_sql
      alias_method :type_to_sql, :type_to_sql_with_enum
    end
  end
end

module ActiveRecord
  module ConnectionAdapters
    class Column
      def initialize_with_enum *args
        initialize_without_enum *args
        @type = simplified_type_with_enum sql_type
        @limit = extract_limit_with_enum sql_type
      end
      alias_method :initialize_without_enum, :initialize
      alias_method :initialize, :initialize_with_enum
      def simplified_type_with_enum field_type
        if field_type =~ /enum/i
          :enum
        else
          simplified_type field_type
        end
      end
      def extract_limit_with_enum field_type
        if field_type =~ /enum\(([^)]+)\)/i
          $1.scan( /'([^']*)'/ ).flatten
        else
          extract_limit field_type
        end
      end
    end
  end
end
module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      def enum *args
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, :enum, options) }
      end
    end
  end
end
