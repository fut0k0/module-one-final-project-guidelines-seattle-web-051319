class CLI
  attr_reader :user

  def initialize(user=nil)
    @user = user
  end
	
	#run method sets user & starts program flow
  def run
    puts "Welcome to the Lyric Builder App!"
		puts " "
    print "Are you a returning user? (y/n): "
    user_input
    main_menu
    binding.pry
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
      input = STDIN.gets.chomp.to_i

      case input
        when 1
          search
        when 2
          print_saved_songs
        when 3
          snippets_menu
        when 4
          loop_control = false
      end
    end
  end

  def print_main_menu
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
			begin
				status = Timeout::timeout(10){
					search_result = RestClient.get("https://api.lyrics.ovh/v1/#{artist}/#{song}")}
				loop_control = false
			rescue Timeout::Error
				puts "Taking too long..."
			end
		end

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

	#snippets_menu presents options for working with snippets & calls appropriate methods
  def snippets_menu
    loop_control = true
      while loop_control

        print_snippets_menu
        input = STDIN.gets.chomp.to_i

        case input
        when 1
          print_snippets
        when 2
          add_snippet
        when 3
          edit_snippets
        when 4
          loop_control = false
        end
      end
  end

  def print_snippets_menu
	  puts " "
    puts "Snippets Menu"
    puts "-------------"
    puts "1. View Snippets"
    puts "2. Add Snippet"
    puts "3. Edit Snippets"
    puts "4. Back to Main Menu"
    puts " "
    print "Enter choice: "
  end

  def print_snippets
    puts " "
    @user.snippets.map{|snippet|
      puts snippet.lyric
    }
    puts " "
    if @user.snippets.size == 0
      puts "There are no snippets!"
      puts " "
      return
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
    song = @user.songs[input-1].lyrics
    song_id = @user.songs[input-1].id
    lyric_array = song.split("\n").each_with_index{|line, i|
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
    source = @user.songs.find_by(id: song_id)
    lyric_artist = source["artist"].gsub("%20", " ").titleize
    lyric_title = source["title"].gsub("%20", " ").titleize
    puts "(This lyric is from #{lyric_title} by #{lyric_artist})"
    puts " "
  end


  def edit_snippets
    puts " "
    @user.snippets.each_with_index{|snippet, i|
      puts "[#{i+1}] #{snippet.lyric}"
    }
    puts " "
    print_snippets_submenu
    puts " "
    print "Enter choice: "
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
        print "All snippets removed from saved snippets."
        puts " "
        @user.snippets.destroy_all
      when 3

      end
  end

  def print_snippets_submenu
    puts "1. Remove snippet"
    puts "2. Clear all snippets"
    puts "3. Back to Snippets Menu"
  end

	#pull_songs displays list of saved songs
  def pull_songs
    saved_songs = @user.songs
    saved_songs.each_with_index {|song, i|
    puts "[#{i+1}] #{song.title.gsub("%20", " ").titleize} by #{song.artist.gsub("%20", " ").titleize}"}
  end
end