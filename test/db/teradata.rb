require 'jdbc_common'

config = {
  :username => 'blog',
  :password => 'blog',
  :adapter  => 'teradata',
  :host => ENV["TERADATA_HOST"] || 'localhost',
  :database => 'weblog_development'
}

ActiveRecord::Base.establish_connection(config)

# Database setup for tests

# create user blog from dbc AS
# password = blog
# perm = 10000000
# spool = 10000000;

# create database weblog_development
# from dbc
# as
# perm = 1000000
# spool = 2000000
# account = 'blog'
# no fallback
# no after journal
# no before journal
# default journal table = weblog_development.journals;

# grant insert on weblog_development.journals to blog;

# grant create table on weblog_development to blog;

# grant select on dbc.UDTInfo to blog;

# Running tests

# requires downloading the teradata jdbc drivers, available here: https://downloads.teradata.com/download/connectivity/jdbc-driver
#CLASSPATH="./terajdbc4.jar:./tdgssconfig.jar:$CLASSPATH" TERADATA_HOST=<host> rake test_teradata