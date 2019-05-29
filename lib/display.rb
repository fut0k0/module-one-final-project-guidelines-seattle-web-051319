def display
  islooped = true
  choice = nil
  while islooped
    puts "Main Menu"
    puts "----------"
    puts "1. Search"
    puts "2. History"
    puts "3. Snippet"
    puts "4. Quit"
    puts "----------"
    print "Enter Number: "
    choice = gets.chomp.to_i

    case choice
      when 1
        puts "Searching"
        search
      when 2
        puts "Historying"
      when 3
        puts "Snippeting"
      when 4
        islooped = false
    end
  end
end
