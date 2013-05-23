require 'arjdbc/teradata/limit_helpers'

module ::ArJdbc
  module Teradata

    def adapter_name
      'Teradata'
    end

    def self.jdbc_connection_class
      ::ActiveRecord::ConnectionAdapters::TeradataJdbcConnection
    end

    def modify_types(tp)
      tp[:primary_key] = 'int not null'
      tp[:integer][:limit] = nil
      tp
    end

    def self.arel2_visitors(config)
      require 'arel/visitors/teradata'
      visitors = ::Arel::Visitors::Teradata
      { 'teradata' => visitors, 'jdbcteradata' => visitors }
    end

    def determine_order_clause(sql)
      return $1 if sql =~ /ORDER BY (.*)$/
      table_name = get_table_name(sql)
      "#{table_name}.#{determine_primary_key(table_name)}"
    end

    def determine_primary_key(table_name)
      primary_key = columns(table_name).detect { |column| column.primary }
      return primary_key.name if primary_key
      # Look for an id column and return it,
      # without changing case, to cover DBs with a case-sensitive collation :
      columns(table_name).each { |column| return column.name if column.name =~ /^id$/i }
      # Give up and provide something which is going to crash almost certainly
      columns(table_name)[0].name
    end

    GET_TABLE_NAME_INSERT_UPDATE_RE = /^\s*(INSERT|EXEC sp_executesql N'INSERT)\s+INTO\s+([^\(\s,]+)\s*|^\s*update\s+([^\(\s,]+)\s*/i

    GET_TABLE_NAME_FROM_RE = /\bFROM\s+([^\(\)\s,]+)\s*/i

    def get_table_name(sql, qualified = nil)
      if sql =~ GET_TABLE_NAME_INSERT_UPDATE_RE
        tn = $2 || $3
        qualified ? tn : unqualify_table_name(tn)
      elsif sql =~ GET_TABLE_NAME_FROM_RE
        qualified ? $1 : unqualify_table_name($1)
      else
        nil
      end
    end

    def unqualify_table_name(table_name)
      table_name.to_s.split('.').last
    end

  end
end

