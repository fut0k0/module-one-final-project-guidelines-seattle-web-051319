require_relative '../config/environment'
require "pry"
require "rest_client"
require "JSON"

class CLI
  attr_reader :user
  def initialize(user=nil)
    @user = user
  end
  #User Methods
  #_____________
  #Get a User
  #Recognize a User
  #Call a User

  def welcome
      puts "Welcome to the Lyric Builder App!!!"

      puts "Are you a Returning user? y/n"
      input = gets.chomp
      #Get User Method
      if input == 'y'
        print "Login name: "
        login_input = gets.chomp
        binding.pry
        user = User.find_by(name: login_input)
        puts "Hello #{user.name}!"
        @user = user
        return user
      elsif input == 'n'
        print "Enter your name: "
        name_input = gets.chomp
        #binding.pry
        user = User.create(name: name_input)
        return user
      end

  end
user = welcome
binding.pry
display(user)

puts "HELLO WORLD"

end
