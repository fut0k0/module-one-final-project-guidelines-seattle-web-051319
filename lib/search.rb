require "pry"
require "rest_client"
require "JSON"
require "timeout"

def search
	stillsearching = true
		while stillsearching
			print "Enter Artist: "
			artist_input = gets.strip.downcase
			artist_input = artist_input.gsub(" ", "%20")
			print "Enter Song Title: "
			song_input = gets.strip.downcase
			song_input = song_input.gsub(" ", "%20")

			song_result = nil
			begin
			status = Timeout::timeout(8){
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
		answer = gets.strip
			if answer == "y"
				Song.create(artist: artist_input, title: song_input , lyrics: text_lyrics)
			elsif answer == "n"
				display
			end
			binding.pry
			0
end
