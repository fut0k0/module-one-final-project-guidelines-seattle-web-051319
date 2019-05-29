
# require "pry"
require "rest_client"
require "JSON"
require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'app'
require_all 'lib'
require_relative '../bin/CLI.rb'
# require_all 'bin'
