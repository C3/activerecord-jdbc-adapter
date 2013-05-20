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
      tp[:integer][:limit] = nil
      tp
    end

  end
end

