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
        #TODO
        #Access database
        #Pull Song Titles, reformat, and list them
        #Allow to delete song or clear history
        puts "Historying"
      when 3
        #TODO
        #Submenu
        #-View Snippet
          #Display all snippets
        #-Create Snippet
          #Choose song from the SOng History list
          #User input = Choose Line number
        #-Delete Snippet
          #User input = Choose Line Number
        #-Quit
        puts "Snippeting"

      when 4
        islooped = false
    end
  end
end
