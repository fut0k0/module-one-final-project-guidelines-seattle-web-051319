#require "pry"
require "rest_client"
#require "JSON"
require 'bundler'
require 'tts'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'app'
require_all 'lib'
require_relative '../bin/cli.rb'
# require_all 'bin'
