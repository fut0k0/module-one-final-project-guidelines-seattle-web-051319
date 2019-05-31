class CLI
  attr_reader :user

  def initialize(user=nil)
    @user = user
  end
	
	#run method sets user & starts program flow
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

	#user_input method establishes new / returning user
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
        puts " "
        puts "Welcome, #{@user.name}!"
        loop_control = false
      end
    end
  end

	#main_menu presents & controls program flow after user is set
  def main_menu
    choice = nil
    loop_control = true

    while loop_control
      print_main_menu
      input = STDIN.gets.chomp.downcase

      case input
        when "s"
          search
        when "a"
          print_saved_songs
        when "w"
          snippets_menu
        when "q"
          loop_control = false
      end
    end
  end

  def print_main_menu
    puts " "
    puts "Main Menu"
    puts "---------"
    puts "(S)earch for lyrics"
    puts "(A)ccess saved songs"
    puts "(W)ork with snippets"
    puts "(Q)uit"
    puts " "
    print "Enter choice: "
  end

	#search accesses the lyrics.ovh API & stores results if desired
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
      puts " "
      puts "Added to saved songs."
		end
  end

	#print_saved_songs displays the user's saved songs
  def print_saved_songs
	  puts " "
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

	#saved_songs_menu displays the menu for working with saved songs
  def saved_songs_menu
    puts "Saved Songs Menu"
    puts "----------------"
    puts "(R)emove song"
    puts "(C)lear all songs"
    puts "(B)ack to Main Menu"
    puts " "
    print "Enter choice: "
    input = STDIN.gets.chomp.downcase
    case input
      when "r"
      	puts " "
        print "Choose song to remove: "
        song = STDIN.gets.chomp.to_i
        song_id = @user.songs[song - 1].id
        @user.songs.destroy(song_id)
        puts " "
        puts "Removed from saved songs."
      when "c"
      	puts " "
        print "All songs removed from saved songs."
        puts " "
        @user.songs.destroy_all
      when "b"
    end
  end

	#snippets_menu presents options for working with snippets & calls appropriate methods
  def snippets_menu
    loop_control = true
      while loop_control

        print_snippets_menu
        input = STDIN.gets.chomp.downcase

        case input
        when "v"
          print_snippets
        when "a"
          add_snippet
        when "e"
          edit_snippets
        when "b"
          loop_control = false
        end
      end
  end

  def print_snippets_menu
	  puts " "
    puts "Snippets Menu"
    puts "-------------"
    puts "(V)iew Snippets"
    puts "(A)dd Snippet"
    puts "(E)dit Snippets"
    puts "(B)ack to Main Menu"
    puts " "
    print "Enter choice: "
  end

  def print_snippets

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

  def add_snippet
	  puts " "
    puts "Saved Songs"
    puts "-----------"
    pull_songs
    puts " "
    print "Enter song number to display the lyrics: "
    input = STDIN.gets.chomp.to_i
    puts " "
    lyrics = @user.songs[input-1].lyrics
    song_id = @user.songs[input-1].id
    lyric_array = lyrics.split("\n").each_with_index{|line, i|
        if line != ""
            puts "[#{i+1}] #{line}"
        end
    }
    puts " "
    print "Enter line number you would like to add to your snippet: "
    line_number = STDIN.gets.chomp.to_i
    line = lyric_array[line_number-1]
    new_snippet = Snippet.create(lyric: line)
    @user.snippets << new_snippet
    puts " "
    puts new_snippet.lyric
    source = @user.songs.find_by(id: song_id)
    artist = source["artist"].gsub("%20", " ").titleize
    title = source["title"].gsub("%20", " ").titleize
    puts "(This line is from #{title} by #{artist})"
    puts " "
  end

  def edit_snippets
    puts " "
    @user.snippets.each_with_index{|snippet, i| puts "[#{i+1}] #{snippet.lyric}"}
    puts " "
    print_snippets_submenu
    puts " "
    print "Enter choice: "
    input = STDIN.gets.chomp.downcase
    case input
      when "r"
        puts " "
        print "Choose snippet to remove: "
        snippet = STDIN.gets.chomp.to_i
        snippet_id = @user.snippets[snippet - 1].id
        @user.snippets.destroy(snippet_id)
        puts " "
        puts "Removed from saved snippets."
        puts " "
      when "c"
        puts " "
        print "All snippets removed from saved snippets."
        puts " "
        @user.snippets.destroy_all
      when "b"
    end
  end

  def print_snippets_submenu
    puts "(R)emove snippet"
    puts "(C)lear all snippets"
    puts "(B)ack to Snippets Menu"
  end

	#pull_songs displays list of saved songs
  def pull_songs
    saved_songs = @user.songs
    saved_songs.each_with_index {|song, i|
    puts "[#{i+1}] #{song.title.gsub("%20", " ").titleize} by #{song.artist.gsub("%20", " ").titleize}"}
  end
end