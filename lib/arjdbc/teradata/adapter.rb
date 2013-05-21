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

    def self.arel2_visitors(config)
      require 'arel/visitors/teradata'
      visitors = ::Arel::Visitors::Teradata
      { 'teradata' => visitors, 'jdbcteradata' => visitors }
    end

  end
end

