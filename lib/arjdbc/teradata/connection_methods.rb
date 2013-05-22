class ActiveRecord::Base
  class << self
    def teradata_connection(config)
      config[:port] ||= 1025
      config[:cop] ||= "ON"
      config[:url] ||= "jdbc:teradata://#{config[:host]}/DATABASE=#{config[:database]},DBS_PORT=#{config[:port]},COP=#{config[:cop]},CHARSET=UTF8"
      config[:driver] ||= "com.teradata.jdbc.TeraDriver"
      jdbc_connection(config)
    end
  end
end

