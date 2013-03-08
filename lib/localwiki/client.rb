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
    # create a specific resource
    # @param resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # @param json is a json object
    # @example wiki.create('page', <json object containing the page tag>)
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
    
    # Returns the number of versions.
    def fetch_num_revision(identifier)
      history = http_get_version(identifier)
      #history["objects"].length
      history.length
    end
    
    # List revisions with most in anti-chronological order.
    def list_revisions(identifier)
      history = http_get_version(identifier)
      #history['objects'].each do |revision|
      history.each do |revision|
        puts revision # display in pretty format if you want
      end
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
    #
    def create_connection
      @site = Faraday.new :url => @hostname
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
    
    # Get page history
    def http_get_version(identifier, params={})
      uri = '/api/page_version/?name=' + identifier
      http_get(uri,params)['objects']
    end
    
    ##
    # http post request
    # @param uri /api/<resource>/
    # @param json is a json object
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

      @site.delete do |req|
        req.url full_url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
      end
    end
  end
end
