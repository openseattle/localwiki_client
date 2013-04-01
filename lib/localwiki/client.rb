require 'faraday'
require 'faraday_middleware'
require 'json'

module Localwiki

  ##
  # A client that wraps the localwiki api for a given server instance
  #
  class Client

    # hostname of the server we'd like to point at
    attr_accessor :hostname

    # localwiki site resource
    attr_reader   :site

    ##
    # Create a LocalWikiClient instance
    # @param hostname domain host of localwiki server
    # @param user localwiki username
    # @param apikey localwiki user's apikey provided by the localwiki server administrator
    # @example Connect to http\:\/\/seattlewiki.net
    #   wiki = LocalwikiClient.new 'seattlewiki.net'
    # @example Connect to http\:\/\/seattlewiki.net with user and apikey for write access
    #   wiki = LocalwikiClient.new 'seattlewiki.net', 'myusername', '89f17088f43b5ae22779365b8d1ff0ed076'
    def initialize hostname, user=nil, apikey=nil
      @user = user
      @apikey = apikey
      @hostname = hostname
      initialize_connection @hostname
    end

    ##
    # Request total count of given resource
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @return [Fixnum] resource count
    # @example Get the number of users
    #   wiki.count('user')
    def count(resource_type)
      path = '/api/' + resource_type.to_s
      response = http_get(path,{limit: '1'})
      response["meta"]["total_count"]
    end

    ##
    # fetch a page by name ("The Page Name" or "The_Page_Name" or "the page name")
    # @param name "The Page Name" or "The_Page_Name" or "the page name"
    # @return [Localwiki::Page] the parsed JSON object from the response body, otherwise the whole http response object
    def page_by_name(name)
      fetch(:page, name)
    end

    ##
    # list of a specific type of resource
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param limit maximum number to return
    # @param params hash of query string params
    # @return [Array, Faraday::Response] array of Localwiki::Resource objects, or the http response object
    # @example Get the first 10 files
    #   wiki.list(:file, 10)
    #   #=> [ #<Localwiki::File>, ... ]
    def list(resource_type,limit=0,params={})
      path = '/api/' + resource_type.to_s
      params.merge!({limit: limit.to_s})
      response = http_get(path,params)
      hydrate_list(resource_type, response['objects'])
    end

    ##
    # fetch a specific resource
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param identifier id, pagename, slug, etc.
    # @param params hash of query string params
    # @example Get the page with the name 'Schedule'
    #   wiki.fetch(:page, 'Schedule')
    #   #=> #<Localwiki::Page>
    # @return [Localwiki::Resource, Faraday::Response] the resource, or the http response object
    def fetch(resource_type,identifier,params={})
      path = '/api/' + resource_type.to_s + '/' + slugify(identifier)
      hydrate(resource_type, http_get(path,params))
    end
    alias_method :read, :fetch

    ##
    # fetch version information for a resource
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param identifier id, pagename, slug, etc.
    # @param params hash of query string params
    # @example Get the version history for page called 'First Page'
    #   wiki.fetch_version(:page, 'First Page')
    # @return [Hash, Faraday::Response] hash from json response body, otherwise the http response object
    def fetch_version(resource_type,identifier,params={})
      path = '/api/' + resource_type.to_s + '_version?name=' + identifier
      http_get(path,params)
    end

    ##
    # number of unique authors that have modified a resource
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param identifier id, pagename, slug, etc.
    # @param params hash of query string params
    # @example Get number of unique authors for the page 'First Page'
    #   wiki.unique_authors(:page, 'First Page')
    # @return [Fixnum] number of unique authors
    def unique_authors(resource_type,identifier,params={})
      json = fetch_version(resource_type,identifier,params)
      json['objects'].map {|entry| entry['history_user']}.uniq.length
    end

    ##
    # create a specific resource. LocalwikiClient must have been initialized with user and apikey.
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param json json string
    # @example Create a page from the json string
    #   wiki.create(:page, {name: 'New Page', content: '<p>A New Page!</p>'}.to_json)
    # @return [Faraday::Response] http response object
    def create(resource_type, json)
      path = '/api/' + resource_type.to_s + '/'
      http_post(path, json)
    end

    ##
    # update a specific resource. LocalwikiClient must have been initialized with user and apikey.
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param identifier id, pagename, slug, etc.
    # @param json json string
    # @example Update an existing page with json string
    #   wiki.update(:page, {name: 'Existing Page', content: '<p>Updated Page!</p>'}.to_json)
    # @return [Faraday::Response] http response object
    def update(resource_type,identifier,json)
      path = '/api/' + resource_type.to_s + '/' + slugify(identifier)
      http_put(path, json)
    end

    ##
    # delete a specific resource. LocalwikiClient must have been initialized with user and apikey.
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param identifier id, pagename, slug, etc.
    # @example Delete the tag 'library'
    #   wiki.delete(:tag, 'library')
    # @return [Faraday::Response] http response object
    def delete(resource_type,identifier)
      path = '/api/' + resource_type.to_s + '/' + slugify(identifier)
      http_delete(path)
    end

    private

    ##
    # prepend the hostname
    # @param path path portion of a url
    # @return [String] entire url
    def full_url(path)
      'http://' + @hostname + path.to_s
    end

    ##
    # Create the appropriate resource object
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param [Hash, Faraday::Response] param object to create resource from, or http response object
    # @return [Localwiki::Resource, Faraday::Response] resource object, or http response object
    def hydrate(resource_type,param)
      # skip if given an http response object
      return param if param.respond_to? :status
      Localwiki::make_one(resource_type,param)
    end

    ##
    # Create array of the appropriate resource objects
    # @param resource_type "site", "page", "user", "file", "map", "tag", "page_tags"
    # @param [Array, Faraday::Response] param array of objects to create resources from, or http response object
    # @return [Array, Faraday::Response] array of resource objects, or http response object
    def hydrate_list(resource_type,param)
      # skip if given an http response object
      return param if param.respond_to? :status
      param.collect do |json_hash|
        Localwiki::make_one(resource_type,json_hash)
      end
    end

    ##
    # initialize Faraday::Connection instance. set @conn and @site
    # @param [String] hostname localwiki server hostname
    def initialize_connection(hostname)
      @conn = Faraday.new :url => hostname do |config|
        config.use FaradayMiddleware::FollowRedirects, limit: 3
        # config.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
        config.adapter Faraday.default_adapter
      end
      @site = fetch('site','1')
      raise "Connection failed. #{@site.status} error returned from #{hostname}." if @site.respond_to? :status
    end
  
    ##
    # http get request
    # @param path /api/<resource>/<resource identifier>
    # @param params hash of query string params
    # @return [Hash, Faraday::Response] hash from json response body, otherwise the http response object
    def http_get(path,params={})
      params.merge!({format: 'json'})
      response = @conn.get full_url(path), params
      JSON.parse(response.body) rescue response
    end
    
    ##
    # http post request
    # @param path /api/<resource>/
    # @param json json string
    # @return [Faraday::Response] http response object
    def http_post(path, json)
      @conn.post do |req|
        configure_request req, path, json
        authorize_request req
      end
    end
    
    ##
    # http put request
    # @param path /api/<resource>/<resource identifier>
    # @param json json string
    # @return [Faraday::Response] http response object
    def http_put(path, json)
      @conn.put do |req|
        configure_request req, path, json
        authorize_request req
      end
    end

    ##
    # http delete request
    # @param path /api/<resource>/<resource identifier>
    # @return [Faraday::Response] http response object
    def http_delete(path)
      @conn.delete do |req|
        configure_request req, path
        authorize_request req
      end
    end

    ##
    # create human readable identifier that is used to create clean urls
    # @param string
    # @return [String]
    def slugify(string)
      string.to_s.strip.gsub(' ', "_")
    end

    ##
    # set request parameters
    # @param req Faraday request object
    # @param path request path
    # @param json json string
    def configure_request(req, path, json=nil)
      req.headers['Content-Type'] = 'application/json'
      req.url full_url(path)
      req.body = json
    end

    ##
    # set request authorization header
    # @param req Faraday request object
    def authorize_request(req)
      req.headers['Authorization'] = "ApiKey #{@user}:#{@apikey}"
    end

  end
end
