class CLI
  attr_accessor :user
  def initialize(user=nil)
    @user = user
    @created = "Created!!!"
  end

  def run
      puts "Welcome to the Lyric Builder App!!!"

      puts "Are you a Returning user? y/n"
      user_input
      display
      binding.pry

  end

  def get_user
    @user
  end

  def user_input
    #binding.pry
    input = STDIN.gets.chomp

    #binding.pry
    if input == 'y'
      returning_user
    elsif input == 'n'
      new_user
    end
  end


    def returning_user
      print "Login name: "
      login_input = STDIN.gets.chomp
      user = User.find_by(name: login_input)
      puts "Hello #{user.name}!"
      returninguser = CLI.new(user)
      @user = returninguser
      #binding.pry
      returninguser
    end

    def new_user
      nameloop = true
      while nameloop
      print "Enter your name: "
      name_input = STDIN.gets.chomp
        if User.find_by(name: name_input)
          puts "#{name_input} is already taken."
          puts "Please try a new name."
        else
          user = User.create(name: name_input)
          newuser = CLI.new(user)
          @user = newuser
          nameloop = false
        end
      end
      newuser
    end

    def menu
      puts "#{@user.user.name}'s Main Menu"
      puts "----------"
      puts "1. Search"
      puts "2. History"
      puts "3. Snippet"
      puts "4. Quit"
      puts "----------"
      print "Enter Number: "
    end

    def display
      islooped = true
      choice = nil
      while islooped
        menu
        choice = STDIN.gets.chomp.to_i

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

    def search
    	stillsearching = true
    		while stillsearching
    			print "Enter Artist: "
    			artist_input = STDIN.gets.strip.downcase
    			artist_input = artist_input.gsub(" ", "%20")
    			print "Enter Song Title: "
    			song_input = STDIN.gets.strip.downcase
    			song_input = song_input.gsub(" ", "%20")

    			song_result = nil
    			begin
    			status = Timeout::timeout(10){
    				song_result = RestClient.get("https://api.lyrics.ovh/v1/#{artist_input}/#{song_input}")
    			}
    			stillsearching = false
    			rescue Timeout::Error
    				puts "Took too long. . ."
    			end
    		end
    		lyrics = JSON.parse(song_result)
    		text_lyrics = lyrics["lyrics"]
    		#binding.pry
    		organized_lyrics = lyrics["lyrics"].split("\n")

    		organized_lyrics.each_with_index {|line, i| puts "[#{i+1}] #{line}"}

    		print "Would you like to save this song lyrics? y/n: "
    		answer = STDIN.gets.strip
    			if answer == "y"
    				new_song = Song.create(artist: artist_input, title: song_input , lyrics: text_lyrics)
            binding.pry
            @user.user.songs << new_song
            puts "Song added."
    				binding.pry
    			# elsif answer == "n"
    			# 	display
    			end
    			# binding.pry
    			# 0
        end



  end


  #User Methods
