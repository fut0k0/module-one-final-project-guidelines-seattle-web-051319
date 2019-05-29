def welcome
    puts "Welcome to the Lyric Builder App!!!"

    puts "Are you a Returning user? y/n"
    input = gets.chomp

    if input == 'y'
      print "Login name: "
      login_input = gets.chomp
      returning_user = User.find_by(name: login_input)
      puts "Hello #{returning_user.name}!"
    elsif input == 'n'
      print "Enter your name: "
      name_input = gets.chomp
      #binding.pry
      User.create(name: name_input)
    end
    display
end
