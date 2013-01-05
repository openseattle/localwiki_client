require 'rest-client'
require 'json/pure'

##
# A client that wraps the localwiki api for a given server instance
#
class LocalwikiClient

  attr_accessor :hostname       # hostname of the server we'd like to point at
  attr_reader   :site_name      # site resource - display name of wiki
  attr_reader   :time_zone      # site resource - time zone of server, e.g. 'America/Chicago'
  attr_reader   :language_code  # site resource - language code of the server, e.g. 'en-us'

  ##
  # Creating a LocalWikiClient instance will get it's site resource data
  #
  #   LocalwikiClient.new 'seattlewiki.net'
  #
  def initialize hostname
    @hostname = hostname
    collect_site_details
  end

  ##
  # Get site resource and set ivars
  #
  def collect_site_details
    site = get_resource('site/1')
    @site_name = site['name']
    @time_zone = site['time_zone']
    @language_code = site['language_code']
  end

  ##
  # http get request
  # url is formatted as http://[url-to-wiki]/[thing-you-want]&format=json
  #
  def get(resource,timeout=120)
    response = RestClient::Request.execute(
        :method => :get,
        :url => 'http://' + @hostname + resource + '&format=json',
        :timeout => timeout)
    JSON.parse(response.body)
  end

  ##
  # http get of a specfic type of resource
  # resource_types are "site", "page", "user", "file", "map"
  # limit is an integer
  # filters is a querystring param in the form "&option=value"
  def get_resource(content_type,limit=0,filters='')
    resource = '/api/' + content_type + '?limit=' + limit.to_s + filters
    get(resource)
  end

  ##
  # Request total_count of given resource
  #
  def total_resources(content_type)
    get_resource(content_type,1)["meta"]["total_count"]
  end

  ##
  # Return a page that matches name ("The Page Name" or "The_Page_Name")
  #
  def page_by_name(name)
    get_resource("page/#{name.gsub!(/\s/, '_')}")
  end

end
