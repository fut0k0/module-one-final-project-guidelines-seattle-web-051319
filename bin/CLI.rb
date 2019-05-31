class CLI
  attr_reader :user

  def initialize(user=nil)
    @user = user
  end

  def run
    puts "[-------Welcome to the Lyrics Builder-------]"
		puts " "
    print "Are you a returning user? (y/n): "
    user_input
    main_menu
    puts " "
    puts "[-----Thank you for using the Lyrics Builder!-----]"
    puts " "
  end

  def user_input
    input = STDIN.gets.chomp.downcase

    if input == "y"
      returning_user
    else input == "n"
      new_user
    end
  end

  def returning_user
    puts " "
    print "Enter user name: "
    input = STDIN.gets.chomp
    @user = User.find_by(name: input)
    puts " "
    puts "Hello, #{@user.name}!"
  end

  def new_user
    loop_control = true

    while loop_control
	    puts " "
      print "Enter your name: "
      input = STDIN.gets.chomp
      if User.find_by(name: input)
        puts " "
        puts "#{input} is already in use."
        puts "Please use a different name."
      else
        @user = User.create(name: input)
        #newuser = CLI.new(user)
        #@user = newuser
        puts " "
        puts "Welcome, #{@user.name}!"
        loop_control = false
      end
    end
  end

  def main_menu_print
    puts " "
    puts "Main Menu"
    puts "---------"
    puts "1. Search for lyrics"
    puts "2. Access saved songs"
    puts "3. Work with snippets"
    puts "4. Quit"
    puts " "
    print "Enter choice: "
  end

  def main_menu
    choice = nil
    loop_control = true

    while loop_control
      main_menu_print
      input = STDIN.gets.chomp.to_i

      case input
        when 1
          search
        when 2
          saved_songs
        when 3
          snippet
        when 4
          loop_control = false
      end
    end
  end

  def search
  	loop_control = true

		while loop_control
			puts " "
			print "Enter artist: "
			artist = STDIN.gets.strip.downcase
			artist = artist.gsub(" ", "%20")
			print "Enter song title: "
			song = STDIN.gets.strip.downcase
			song = song.gsub(" ", "%20")

			search_result = nil
      def sleeping
        sleep(0.7)
      end

      begin
      status = Timeout::timeout(10){

        print "Searching Song"
        sleeping
        print " ."
        sleeping
        print " ."
        sleeping
        print " ."
        sleeping
        print " ."
        sleeping
        print " ."

        search_result = RestClient.get("https://api.lyrics.ovh/v1/#{artist}/#{song}")
      }
      loop_control = false
      rescue Timeout::Error
        puts " "
        puts "Took too long. . ."
      end
    end
    puts " "

		lyrics = JSON.parse(search_result)
		lyrics_text = lyrics["lyrics"]
		lyrics_formatted = lyrics_text.split("\n")
		lyrics_formatted.each_with_index {|line, i| puts "[#{i+1}] #{line}"}

		puts " "
		print "Would you like to save this song? (y/n): "
		answer = STDIN.gets.strip.downcase
		if answer == "y"
			new_song = Song.create(artist: artist, title: song, lyrics: lyrics_text)
      @user.songs << new_song
      puts "Added to saved songs."
		end
  end

  def saved_songs
    saved_songs = @user.songs
    saved_songs.each_with_index {|song, i|
    puts "[#{i+1}] #{song.title.gsub("%20", " ").titleize} by #{song.artist.gsub("%20", " ").titleize}"}
    puts " "
    if saved_songs.size == 0
      puts "There are no saved songs!"
      puts " "
      return
    end
    saved_songs_menu
  end

  def saved_songs_menu
    puts "1. Remove song"
    puts "2. Clear all songs"
    puts "3. Back to Main Menu"
    puts " "
    print "Enter choice: "
    input = STDIN.gets.chomp.to_i
    case input
      when 1
      	puts " "
        print "Choose song to remove: "
        song = STDIN.gets.chomp.to_i
        song_id = @user.songs[song - 1].id
        @user.songs.destroy(song_id)
        puts " "
        puts "Removed from saved songs."
      when 2
      	puts " "
        print "All songs removed from saved songs."
        puts " "
        @user.songs.destroy_all
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
    puts " "
    print "Enter choice: "
  end

  # def users_saved_search
  #   listofsongs = @user.user.songs
  #   listofsongs.each_with_index {|song, i|
  #     puts "[#{i+1}] Artist: #{song.artist} - Title: #{song.title}"
  #   }
  # end
  def pulled_songs
    saved_songs = @user.songs
    saved_songs.each_with_index {|song, i|
    puts "[#{i+1}] #{song.title.gsub("%20", " ").titleize} by #{song.artist.gsub("%20", " ").titleize}"}
  end

  def snippet_add
    puts "----List of Saved Songs----"
    pulled_songs
    puts " "
    print "Enter number of song choice to display the lyrics: "
    input = STDIN.gets.chomp.to_i
    song_chosen = @user.songs[input-1].lyrics
    song_id_saved = @user.songs[input-1].id
    #binding.pry
    lyric_array = song_chosen.split("\n").each_with_index{|line, i|
        if line != ""
            puts "[#{i+1}] #{line}"
        end
    }
    puts " "
    print "Enter line number you would like to add to your snippet: "
    lyric_line_number = STDIN.gets.chomp.to_i
    lyric_line = lyric_array[lyric_line_number-1]
    new_snippet = Snippet.create(lyric: lyric_line)
    @user.snippets << new_snippet
    puts " "
    puts new_snippet.lyric
    puts " "
    #puts new_snippet
    source = @user.songs.find_by(id: song_id_saved)
    lyric_artist = source["artist"].gsub("%20", " ").titleize
    lyric_title = source["title"].gsub("%20", " ").titleize
    puts "This lyric is from [#{lyric_title}] by [#{lyric_artist}]"
    puts " "
  end

  def snippet_view
    puts ""
    if @user.snippets.size == 0
      puts "There are no Snippets!!"
      puts " "
      return
    else
      puts ""
      @user.snippets.map{|ly|
        puts ly.lyric
      }
      @user.snippets.map{|l|
          l.lyric.play("en", 1)
      }
    end

  end


  def snippet_edit
    puts ""
    @user.snippets.each_with_index{|l, i|
      puts "[#{i+1}] #{l.lyric}"
    }
    puts ""
    snippet_edit_submenu
    print "Enter your choice: "
    input = STDIN.gets.chomp.to_i
    case input
      when 1
        puts " "
        print "Choose snippet to remove: "
        snippet = STDIN.gets.chomp.to_i
        snippet_id = @user.snippets[snippet - 1].id
        @user.snippets.destroy(snippet_id)
        puts " "
        puts "Removed from saved snippets."
        puts " "
      when 2
        puts " "
        print "All songs removed from saved snippets."
        puts " "
        @user.snippets.destroy_all
      when 3

      end
  end

  def snippet_edit_submenu
    #Optional: Move Snippet
    puts ""
    puts "1. Remove snippet"
    puts "2. Clear all snippets"
    puts "3. Back to Main Menu"
    puts " "
  end

  def snippet
    puts ""
    puts "[-----#{@user.name}'s Snippet-----]"
    loop_control = true
      while loop_control

        snippet_menu_display
        snippet_menu_command = STDIN.gets.chomp.to_i

        case snippet_menu_command
        when 1
          snippet_view
        when 2
          snippet_add
        when 3
          snippet_edit
        when 4
          loop_control = false
        end
      end
  end

end
