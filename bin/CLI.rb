class CLI
  attr_reader :user
  
  def initialize(user=nil)
    @user = user
  end

  def run
    puts "Welcome to the Lyric Builder App!!!"
		puts " "
    print "Are you a returning user? (y/n): "
    user_input
    main_menu
    binding.pry
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
          puts "Snippeting"
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
      puts "Added to saved songs."
		end
  end
  
  def saved_songs
    saved_songs = @user.songs
    saved_songs.each_with_index {|song, i|
    puts "[#{i+1}] #{song.title.gsub("%20", " ").titleize} by #{song.artist.gsub("%20", " ").titleize}"}
    puts " "
    if saved_songs.size == 0
      puts "History is empty!"
      puts " "
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
end
