class ActiveRecord::Base
  class << self
    def teradata_connection(config)
      config[:port] ||= 1025
      config[:url] ||= "jdbc:teradata://#{config[:host]}/DATABASE=#{config[:database]},DBS_PORT=#{config[:port]},COP=OFF"
      config[:driver] ||= "com.teradata.jdbc.TeraDriver"
      config[:adapter_spec] = ::ArJdbc::Teradata
      jdbc_connection(config)
    end
  end
end

