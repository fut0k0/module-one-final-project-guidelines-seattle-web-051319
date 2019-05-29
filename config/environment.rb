require 'bundler'
# require "pry"
# require "rest_client"
# require "JSON"
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'app'
require_all 'lib'
