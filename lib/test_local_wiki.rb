#!/usr/bin/env ruby
#require 'localwiki_client'
require '../spec/helper.rb'
require './localwiki_client.rb'

wiki = LocalwikiClient.new 'ec2-54-234-151-52.compute-1.amazonaws.com', 'hcanzl', '698eeb103e50a2e314ce0c4d3e9efce994a789a4'

puts wiki.hostname
puts wiki.site_name
puts wiki.time_zone
puts wiki.language_code
puts wiki.count('user')

#puts wiki.list("page")
#puts wiki.list("user")
puts "###############"
puts wiki.fetch("page", "dogs3")
puts "###############"

#puts wiki.page_by_name("dogs3")
#puts wiki.methods

json_file = load_json './page_fetch.json'

#json = {
#    "content": "<p> Experience is like no other. </p>",
#    "id": 158,
#    "name": "Bradfordville Blues Club",
#    "resource_uri": "/api/page/Bradfordville_Blues_Club",
#    "slug": "bradfordville blues club"
#}

#puts page_to_add.is_a?(Hash)
#puts page_to_add
wiki.create("page", "Bradfordville", json_file)

#wiki2 = LocalwikiClient.new 'ec2-54-234-151-52.compute-1.amazonaws.com'
#puts wiki2.count('user')

#wiki2 = LocalwikiClient.new 'ec2-54-234-151-52.compute-1.amazonaws.com'
#wiki2.create("page", "dogs6", json_file)
#puts wiki2.count('user')