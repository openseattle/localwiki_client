require 'localwiki_client'
require 'geocoder'
require 'uri'

def print_help
  puts 'Return list of wiki pages (that have location information) near a street address.'
  puts "Parameters:"
  puts "\thostname: localwiki server, e.g.: seattlewiki.net"
  puts "\taddress: street address, e.g.: 350 Monroe Avenue NE, Renton WA"
  puts "\tmiles: number of miles to search (defaults to 1)"
  puts "Usage:\n\tnearby_wiki_pages <hostname> <street address> <miles>"
  exit
end

def uri_to_name uri
  URI.decode(uri.match(/\/([^\/]+)$/)[1]).gsub('_', ' ')
end

print_help if ARGV.length < 2

hostname, address, miles = ARGV

coordinates = Geocoder.coordinates address
puts "Finding wiki pages within #{miles} miles of #{coordinates.inspect}"

wiki = LocalwikiClient.new hostname
maps = wiki.list :map
#puts maps.inspect

pages = maps.collect do |map|
  next unless map.single_point?
  actual_distance = Geocoder::Calculations.distance_between([map.lat, map.long], coordinates.reverse)
  #puts actual_distance.to_s + ' :: ' + map.page
  if actual_distance < miles.to_f
    #print '.'
    {:dist => actual_distance, :map => map}
  end
end

pages.compact!
if pages.size < 1
  puts 'No results found.'
else
  puts "\nMiles :: Page"
  pages.sort_by{|i|i[:dist]}.each do |entry|
    puts sprintf("%5.2f", entry[:dist]) + " :: #{uri_to_name(entry[:map].page)}"
  end
end
