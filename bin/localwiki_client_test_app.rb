#!/usr/bin/env ruby
require 'localwiki_client'

wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com',
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
#wiki = LocalwikiClient.new 'seattlewiki.net'
puts "argument is: #{ARGV[0]}\n\n"

case ARGV[0]
when 'site_info'
  puts wiki.hostname
  puts wiki.site_name
  puts wiki.time_zone
  puts wiki.language_code
  puts wiki.count('user')
  
when 'get'
  puts "Starting Fetch cats ###############"
  puts wiki.fetch("page", "cats")
  puts "End Fetch ###############"
    
when 'create'
  puts "***********Creating Luna Park Cafe Page ##############"
  json_file = File.open("page_fetch.json", 'r').read
  response = wiki.create("page", json_file)
  puts "create status = #{response.status}"
  puts "***********End Create Operation ##############"
  
when 'update'  
  puts "***********Starting Update Luna Park Cafe ##############"
  #puts wiki.update('page', 'cats', {content: '<p>Created and updated again!</p>'}.to_json)
  json_file = File.open("page_update.json", 'r').read
  response = wiki.update("page", 'Luna_Park_Cafe', json_file)
  puts "update status = #{response.status}"
  puts "***********End Update Operation ##############"
  
when 'delete'
  puts "***********Deleting Luna Park Cafe"
  response = wiki.delete('page', 'Luna_Park_Cafe')
  #response = wiki.delete('page', 'huh')
  puts "delete status = #{response.status}"
  puts "***********End Delete Operation"

when 'history'
  puts "START GET History for Alko ##############"
  #puts wiki.fetch_version('cats', {}, true)
  puts wiki.fetch_num_revision('Alki')
  puts wiki.list_revisions('Alki')
  puts "END GET History for cats ##############"
  
else
  puts "#{ARGV[0]} is an Invalid Argument."
end
