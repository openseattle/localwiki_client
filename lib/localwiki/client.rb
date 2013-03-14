require 'faraday'
require 'json/pure'

module Localwiki

  ##
  # A client that wraps the localwiki api for a given server instance
  #
  class Client

    attr_accessor :hostname       # hostname of the server we'd like to point at
    attr_reader   :site_name      # site resource - display name of wiki
    attr_reader   :time_zone      # site resource - time zone of server, e.g. 'America/Chicago'
    attr_reader   :language_code  # site resource - language code of the server, e.g. 'en-us'

    ##
    # Create a LocalWikiClient instance
    #
    #   LocalwikiClient.new 'seattlewiki.net'
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
    #
    def count(resource)
      list(resource.to_s,1)["meta"]["total_count"]
    end

    ##
    # fetch a page by name ("The Page Name" or "The_Page_Name" or "the page name")
    # @param name "The Page Name" or "The_Page_Name" or "the page name"
    # @return [Hash] the parsed JSON object from the response body, otherwise the whole http response object
    #
    def page_by_name(name)
      if name.include? ' '
        "#{name.gsub!(/\s/, '_')}"
      end
      fetch(:page,name);
    end

    ##
    # list of a specific type of resource
    # resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # limit is an integer
    # params is a hash of query string params
    def list(resource,limit=0,params={})
      uri = '/api/' + resource.to_s
      params.merge!({limit: limit.to_s})
      http_get(uri,params)
    end

    ##
    # fetch a specific resource
    # resources are "site", "page", "user", "file", "map", "tag", "page_tag"
    # identifier is id, pagename, slug, etc.
    # params is a hash of query string params
    def fetch(resource,identifier,params={})
      uri = '/api/' + resource.to_s + '/' + identifier
      http_get(uri,params)
    end

    ##
    # create a specific resource
    # resources are "site", "page", "user", "file", "map", "tag", "page_tag"
    def create(resource,identifier,json)
      raise 'Not Yet Implemented'
    end

    ##
    # update a specific resource
    # resources are "site", "page", "user", "file", "map", "tag", "page_tag"
    # identifier is id, pagename, slug, etc.
    def update(resource,identifier,json)
      raise 'Not Yet Implemented'
    end

    ##
    # delete a specific resource
    # resources are "site", "page", "user", "file", "map", "tag", "page_tag"
    # identifier is id, pagename, slug, etc.
    def delete(resource,identifier)
      raise 'Not Yet Implemented'
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
    # url is formatted as http://[@hostname]/[thing(s)-you-want]?[params]
    #
    def http_get(uri,params={})
      params.merge!({format: 'json'})
      full_url = 'http://' + @hostname + uri.to_s
      response = @site.get full_url, params
      JSON.parse(response.body)
    end

    def http_post()
      raise 'Not Yet Implemented'
    end

    def http_put()
      raise 'Not Yet Implemented'
    end

    def http_delete()
      raise 'Not Yet Implemented'
    end

  end
end
