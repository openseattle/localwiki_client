require 'rest-client'
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
    def initialize hostname
      @hostname = hostname
      collect_site_details
    end

    ##
    # Get site resource and set instance variables
    #
    def collect_site_details
      site = fetch('site','1',['format=json'])
      @site_name = site['name']
      @time_zone = site['time_zone']
      @language_code = site['language_code']
    end

    ##
    # Request total count of given resource
    #
    def count(resource)
      list(resource.to_s,1)["meta"]["total_count"]
    end

    ##
    # fetch a page by name ("The Page Name" or "The_Page_Name" or "the page name")
    #
    def page_by_name(name)
      fetch(:page,"#{name.gsub!(/\s/, '_')}")
    end

    ##
    # list of a specific type of resource
    # resource are "site", "page", "user", "file", "map", "tag", "page_tag"
    # limit is an integer
    # filters is a query string param in the form "&option=value"
    def list(resource,limit=0,filters=[])
      uri = '/api/' + resource.to_s
      filters << "limit=#{limit}"
      http_get(uri,filters)
    end

    ##
    # fetch a specific resource
    # resources are "site", "page", "user", "file", "map", "tag", "page_tag"
    # identifier is id, pagename, slug, etc.
    # filters is array of 'option=value'
    def fetch(resource,identifier,filters=[])
      uri = '/api/' + resource.to_s + '/' + identifier
      http_get(uri,filters)
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
    # http get request
    # url is formatted as http://[url-to-wiki]/[thing(s)-you-want]&filters
    #
    def http_get(uri,filters=['format=json'],timeout=120)
      if filters.select { |value| value.match /format/ }.empty?
        filters << 'format=json'
      end
      response = RestClient::Request.execute(
          :method => :get,
          :url => 'http://' + @hostname + uri.to_s + '?' + filters.join("&"),
          :timeout => timeout)
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
