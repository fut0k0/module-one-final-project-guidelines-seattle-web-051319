require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'run console CLI application'
task :run do
  #puts "hi run"
  cli = CLI.new
  cli.run
end
