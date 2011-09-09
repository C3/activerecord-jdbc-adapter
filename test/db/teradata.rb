config = {
  :username => 'blog',
  :password => 'blog',
  :adapter  => 'teradata',
  :host => ENV["TERADATA_HOST"] || 'localhost',
  :database => 'weblog_development'
}

ActiveRecord::Base.establish_connection(config)