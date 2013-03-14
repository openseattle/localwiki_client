require 'faraday'
require 'json'

module Localwiki

  ##
  # A client that wraps the localwiki api for a given server instance
  #
  class Client

    require 'date'
    require 'active_support/all'

    # hostname of the server we'd like to point at
    attr_accessor :hostname
    
    # site resource - display name of wiki
    attr_reader   :site_name
    
    # site resource - time zone of server, example: 'America/Chicago'
    attr_reader   :time_zone      
    
    # site resource - language code of the server, example: 'en-us'
    attr_reader   :language_code  

    ##
    # Create a LocalWikiClient instance
    #
    # @example LocalwikiClient.new 'seattlewiki.net'
    #
    def initialize hostname, user=nil, apikey=nil
      @hostname = hostname
      @user = user
      @apikey = apikey
      create_connection
      collect_site_details
    end

    ##
    # Request total count of given resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @return [Fixnum] resource count
    # @example wiki.count('user')
    def count(resource)
      list(resource.to_s,1)["meta"]["total_count"]
    end

    ##
    # fetch a page by name ("The Page Name" or "The_Page_Name" or "the page name")
    # @param name "The Page Name" or "The_Page_Name" or "the page name"
    # @return [Hash] the parsed JSON object from the response body, otherwise the whole http response object
    def page_by_name(name)
      fetch(:page,"#{name.gsub!(/\s/, '_')}")
    end

    ##
    # list of a specific type of resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param limit is an integer
    # @param params is a hash of query string params
    # @return [Hash] the parsed JSON object from the response body, otherwise the whole http response object
    def list(resource,limit=0,params={})
      uri = '/api/' + resource.to_s
      params.merge!({limit: limit.to_s})
      http_get(uri,params)
    end

    ##
    # fetch a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param identifier is id, pagename, slug, etc.
    # @param params is a hash of query string params
    # @example wiki.update('page', '<page tag>')
    # @return [Hash] the parsed JSON object from the response body, otherwise the whole http response object
    def fetch(resource,identifier,params={})
      uri = '/api/' + resource.to_s + '/' + identifier
      http_get(uri,params)
    end
    alias_method :read, :fetch



    def fetch_version(resource,identifier,params={})
      uri = '/api/' + resource.to_s + '?name=' + identifier
      the_hash = http_get(uri,params)
      num_objects = the_hash["objects"].length
      puts "XXXXXXXXXXXXXXXXXXXXXXXXX"
      puts "The number of versions of this page is:  #{num_objects}"
      puts "XXXXXXXXXXXXXXXXXXXXXXXXX"
      puts "The versions of the page are listed below with the most recent first-"
      puts "XXXXXXXXXXXXXXXXXXXXXXXXX"
      the_hash["objects"][0..num_objects].each do |revision|
        condensed_history_hash = revision.tap{|rev| rev.delete("content"); rev.delete("id"); rev.delete("name"); rev.delete("resource_uri"); rev.delete("slug")}
        p condensed_history_hash, 'XXXXXXXXXXXXXXXXXXXXXXXXX'
      end


      val = the_hash["objects"][0]["history_date"]  #val finds history date (ex. 2013-03-01T12:34)
      time_val = val.to_datetime
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "The date of change for this 1st revision is: #{time_val}"
                                                    #DateTime.now is current date and time (ex. 2013-03-12T12:12) and -15 means you are subtracting 15 days from today.
                                                    # x will return a value of true if (val) is within last 15 days and false if it is outside of 15 days.
      date_range = time_val >= (DateTime.now-15)
      puts date_range, ">>>>>>>>>>>If 'true' then revision was made in last 14 days.  If false then revision was made more than 14 days ago."


      val = the_hash["objects"][1]["history_date"]  #val finds history date (ex. 2013-03-01T12:34)
      time_val = val.to_datetime
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "The date of change for this 2nd revision is: #{time_val}"
                                                    #DateTime.now is current date and time (ex. 2013-03-12T12:12) and -15 means you are subtracting 15 days from today.
                                                    # x will return a value of true if (val) is within last 15 days and false if it is outside of 15 days.
      date_range = time_val >= (DateTime.now-15)
      puts date_range, ">>>>>>>>>>>If 'true' then revision was made in last 14 days.  If false then revision was made more than 14 days ago."


      val = the_hash["objects"][2]["history_date"]  #val finds history date (ex. 2013-03-01T12:34)
      time_val = val.to_datetime
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "The date of change for this 3rd revision is: #{time_val}"
                                                    #DateTime.now is current date and time (ex. 2013-03-12T12:12) and -15 means you are subtracting 15 days from today.
                                                    # x will return a value of true if (val) is within last 15 days and false if it is outside of 15 days.
      date_range = time_val >= (DateTime.now-15)
      puts date_range, ">>>>>>>>>>>If 'true' then revision was made in last 14 days.  If false then revision was made more than 14 days ago."


      val = the_hash["objects"][6]["history_date"]  #val finds history date (ex. 2013-03-01T12:34)
      time_val = val.to_datetime
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "The date of change for this 7th revision is: #{time_val}"
                                                    #DateTime.now is current date and time (ex. 2013-03-12T12:12) and -15 means you are subtracting 15 days from today.
                                                    # x will return a value of true if (val) is within last 15 days and false if it is outside of 15 days.
      date_range = time_val >= (DateTime.now-15)
      puts date_range, ">>>>>>>>>>>If 'true' then revision was made in last 14 days.  If false then revision was made more than 14 days ago."
     end




    ##
    # create a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param json is a json object
    # @example wiki.create('page', <json object containing the page tag>)
    # @return [HTTPResponse] the http response object
    def create(resource, json)
      uri = '/api/' + resource.to_s + '/'
      http_post(uri, json)
    end

    ##
    # update a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param identifier is id, pagename, slug, etc.
    # @param json is a json object
    # @example wiki.update('page', '<page tag>', <json object>)
    # @return [HTTPResponse] the http response object
    def update(resource,identifier,json)
      uri = '/api/' + resource.to_s + '/' + identifier
      http_put(uri, json)  
    end

    ##
    # delete a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param identifier is id, pagename, slug, etc.
    # @example wiki.delete('page', '<page tag>')
    # @return [HTTPResponse] the http response object
    def delete(resource,identifier)
      uri = '/api/' + resource.to_s + '/' + identifier
      http_delete(uri)
    end

    private



    ##
    # Get site resource and set instance variables
    #
    def collect_site_details
      site = fetch('site','1')
      @site_name = site['name']
      @time_zone = site['time_zone']
      @language_code = site['language_code']
    end

    ##
    # create Faraday::Connection instance and set @site
    # @return [Connection] the Uniform Resource Identifier to which we are connected
    def create_connection
      @site = Faraday.new :url => @hostname
    end
  
    ##
    # http get request
    # @param uri /api/<resource>/<resource identifier>
    # @param params is a hash of query string params
    # @return [Hash] the parsed JSON object, otherwise the  http response object
    def http_get(uri,params={})
      params.merge!({format: 'json'})
      full_url = 'http://' + @hostname + uri.to_s
      response = @site.get full_url, params
      JSON.parse(response.body) rescue response
    end
    
    ##
    # http get request
    # @param uri /api/<resource>/<resource identifier>
    # @param params is a hash of query string params
    # @return [Hash] the parsed JSON object, otherwise the  http response object
    def http_alt_get(uri,params={})
      params.merge!({format: 'json'})
      full_url = 'http://' + @hostname + uri.to_s
      response = @site.get full_url, params
      puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      puts "The full url is: #{full_url}"
      puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      puts "And the response object is: "
      puts response.inspect
      puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      my_hash = JSON.parse(response.body)  rescue response
      puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      puts "And the parsed body is: "
      puts my_hash
      puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      my_hash
    end
    
    ##
    # http post request
    # @param uri /api/<resource>/
    # @param json is a json object
    # @return [HTTPResponse] the http response object
    def http_post(uri, json)
      full_url = 'http://' + @hostname + uri.to_s
      
      @site.post do |req|
        req.url full_url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
        req.body = json
      end
    end
    
    ##
    # http put request
    # @param uri /api/<resource>/<resource identifier>
    # @param json is a json object
    # @return [HTTPResponse] the http response object
    def http_put(uri, json)
      full_url = 'http://' + @hostname + uri.to_s
      
      @site.put do |req|
        req.url full_url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
        req.body = json
      end
    end

    ##
    # http delete request
    # @param uri /api/<resource>/<resource identifier>
    # @return [HTTPResponse] the http response object
    def http_delete(uri)
      full_url = 'http://' + @hostname + uri.to_s

      @site.delete do |req|
        req.url full_url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
      end
    end
  end
end
