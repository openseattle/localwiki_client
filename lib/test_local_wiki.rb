#!/usr/bin/env ruby
require 'localwiki_client'
wiki = LocalwikiClient.new 'seattlewiki.net'
puts wiki.hostname
puts wiki.site_name
puts wiki.time_zone
puts wiki.language_code
puts wiki.total_resources('user')
