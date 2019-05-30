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
            history
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
            snippet

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

    		organized_lyrics = lyrics["lyrics"].split("\n")

    		organized_lyrics.each_with_index {|line, i| puts "[#{i+1}] #{line}"}

    		print "Would you like to save this song lyrics? y/n: "
    		answer = STDIN.gets.strip
    			if answer == "y"
    				new_song = Song.create(artist: artist_input, title: song_input , lyrics: text_lyrics)

            @user.user.songs << new_song
            puts "Song added."
    			end

        end

        def users_saved_search
          listofsongs = @user.user.songs
          listofsongs.each_with_index {|song, i|
            puts "[#{i+1}] Artist: #{song.artist} - Title: #{song.title}"

          }

        end

        def history
          users_saved_search
          puts "1. Remove Song"
          puts "2. Clear Songs"
          puts "3. Main Menu"
          print "Enter choice: "
          input = STDIN.gets.chomp.to_i
          case input
            when 1
              print "Choose line number to remove: "
              removing = STDIN.gets.chomp.to_i
              songtodelete = @user.user.songs[removing-1].id
              @user.user.songs.destroy(songtodelete)
              puts "Deleting song. . ."
              #binding.pry
            when 2
              print "DESTROYING ALL SONGS!!!"
              @user.user.songs.destroy_all
            when 3

          end
        end

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
        def snippet_menu_display
          puts "1. View Snippet"
          puts "2. Add to Snippet"
          puts "3. Edit Snippet"
          puts "4. Back"
          print "Enter choice: "
        end

        # def users_saved_search
        #   listofsongs = @user.user.songs
        #   listofsongs.each_with_index {|song, i|
        #     puts "[#{i+1}] Artist: #{song.artist} - Title: #{song.title}"
        #   }
        # end

        def snippet_add
          puts "----List of Saved Songs----"
          users_saved_search
          print "Enter number of song choice to display the lyrics: "
          song_choice_input = STDIN.gets.chomp.to_i
          song_chosen = @user.user.songs[song_choice_input-1].lyrics
          song_id_saved = @user.user.songs[song_choice_input-1].id
          #binding.pry
          lyric_array = song_chosen.split("\n").each_with_index{|line, i|
              if line != ""
                  puts "[#{i+1}] #{line}"
              end
          }

          print "Enter line number you would like to add to your snippet: "
          lyric_line_number = STDIN.gets.chomp.to_i
          lyric_line = lyric_array[lyric_line_number-1]
          #@user.user.snippets << @user.user.songs

          puts lyric_line
          saved_lyric_source = @user.user.songs.find_by(id: song_id_saved)
          #binding.pry
          lyric_artist = saved_lyric_source["artist"].gsub("%20", " ")
          lyric_title = saved_lyric_source["title"].gsub("%20", " ")
          puts "This lyric is from [#{lyric_title}] by [#{lyric_artist}]"

          binding.pry
        end

        def snippet_edit

        end

        def snippet
          puts "[-----#{@user.user.name}'s Snippet-----]"
          snippetrunning = true
            while snippetrunning

              snippet_menu_display
              snippet_menu_command = STDIN.gets.chomp.to_i

              case snippet_menu_command
              when 1
                puts "MY SNIPPET"
              when 2
                snippet_add
              when 3
                snippet_edit
              when 4
                snippetrunning = false
              end
            end
        end

  #CLI end
  end
