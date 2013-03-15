require 'faraday'
require 'json'

module Localwiki

  ##
  # A client that wraps the localwiki api for a given server instance
  #
  class Client

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
    def page_by_name(name)
      fetch(:page,"#{name.gsub!(/\s/, '_')}")
    end

    ##
    # list of a specific type of resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param limit is an integer
    # @param params is a hash of query string params
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
    def fetch(resource,identifier,params={})
      uri = '/api/' + resource.to_s + '/' + identifier
      http_get(uri,params)
    end
    alias_method :read, :fetch

    ##
    # fetch a specific resource
    # @param resource is "page_version"
    # @param identifier is id, pagename, slug, etc.
    # @param params is a hash of query string params
    # @example wiki.update('page', '<page tag>')
    # @return [Hash] the parsed JSON object from the response body, otherwise the whole http response object
    def fetch_version(resource,identifier,params={},extract_a_hist_id=false)
      uri = '/api/' + resource.to_s + '?name=' + identifier
      the_hash = http_get(uri,params)
      if extract_a_hist_id
        extract_first_history_id the_hash
      else
        the_hash
      end
    end


    ##
    # create a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param json is a json object
    # @example wiki.create('page', <json object containing the page tag>)
    def create(resource, json)
      uri = '/api/' + resource.to_s + '/'
      puts 'CREATECREATECREATE ' + 'json: ' + json
      http_post(uri, json)
    end

    ##
    # update a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param identifier is id, pagename, slug, etc.
    # @param json is a json object
    # @example wiki.update('page', '<page tag>', <json object>)
    def update(resource,identifier,json)
      uri = '/api/' + resource.to_s + '/' + identifier
      http_put(uri, json)  
    end

    ##
    # delete a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param identifier is id, pagename, slug, etc.
    # @example wiki.delete('page', '<page tag>')
    def delete(resource,identifier)
      uri = '/api/' + resource.to_s + '/' + identifier
      http_delete(uri)
    end

    private


    ##
    # Get resources version history
    #  
    def fetch_history(resource,identifier,params={})
      uri = '/api/' + resource.to_s + '?name=' + identifier
      the_hash = http_get(uri,params)
      val = the_hash["objects"][0]["history_date"]  #val finds history date (ex. 2013-03-01T12:34)
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "And val is: #{val}" 
      time_val = val.to_datetime
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      puts "And time_val is: #{time_val}" 
      #DateTime.now is current date and time (ex. 2013-03-12T12:12) and -15 means you are subtracting 15 days from today. 
      # x will return a value of true if (val) is within last 15 days and false if it is outside of 15 days.
      x = time_val >= (DateTime.now-15)
      puts "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      p x
    end

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
    #
    def create_connection
      #@site = Faraday.new :url => @hostname
      @site = Faraday.new(:url => @hostname) do |faraday|
        faraday.request  :url_encoded            # form-encoded POST params          
        faraday.response :logger                 # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter # make requests with Net::HTTP
      end  
    end
  
    ##
    # http get request
    # @param uri /api/<resource>/<resource identifier>
    # @param params is a hash of query string params
    def http_get(uri,params={})
      params.merge!({format: 'json'})
      full_url = 'http://' + @hostname + uri.to_s
      response = @site.get full_url, params
      JSON.parse(response.body) rescue response
    end
    
    ##
    # http post request
    # @param uri /api/<resource>/
    # @param json is a json object
    def http_post(uri, json)
      full_url = 'http://' + @hostname + uri.to_s

      puts 'POSTPOSTPOSTPOST ' + 'json: ' +json
      puts 'Full URL: ' + full_url
      
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
    def http_delete(uri)
      full_url = 'http://' + @hostname + uri.to_s
      response = @site.delete full_url
      response = @site.delete do |site|
          site.url full_url
          site.headers['Content-Type'] = 'application/json'
          site.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
        end

      if response.status == 204
        'URL removed: ' + full_url
      elsif response.status == 404
        'URL not found: ' + full_url
      else
        'Status response: ' + response.status   
      end  
      
    end
  end
end
