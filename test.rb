require "pry"
require "rest_client"
require "JSON"

puts "artist:"
artist = gets.strip.downcase
artist = artist.gsub(" ", "%20")
puts " "
puts "song title:"
song = gets.strip.downcase
song = song.gsub(" ", "%20")

response = RestClient.get("https://api.lyrics.ovh/v1/#{artist}/#{song}")
x = JSON.parse(response)
puts x

y = x["lyrics"].split("\n")

y.each_with_index {|z, i| puts "[#{i+1}] #{z}"}

puts " "
puts "save a line? (y/n)"
answer = gets.strip
if answer == "y"
	puts "store something somewhere"
else
	puts "return to different menu or something"
end
binding.pry
0