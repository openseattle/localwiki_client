require 'rest-client'
require 'json/pure'

class LocalWiki

  require 'rest-client'
  require 'json/pure'

  attr_accessor  :base_url
  attr_reader   :site_name, :time_zone, :language_code

  def initialize base_url
    @base_url = base_url
    collect_site_details
  end

  def collect_site_details
    site = get_resource('site/1')
    @site_name = site['name']
    @time_zone = site['time_zone']
    @language_code = site['language_code']
  end

  def currently_online?
    RestClient.get @base_url if @base_url
  end

  # url is formatted as http://[url-to-wiki]/[thing-you-want]&format=json
  def get(resource,timeout=120)
    response = RestClient::Request.execute(
        :method => :get,
        :url => 'http://' + @base_url + resource + '&format=json',
        :timeout => timeout)
    JSON.parse(response.body)
  end

  # resource_types = ["site", page", "user", "file", "map"]
  def get_resource(content_type,limit=0,filters='')
    resource = '/api/' + content_type + '?limit=' + limit.to_s + filters
    get(resource)
  end

  def total_resources(content_type)
    get_resource(content_type)["meta"]["total_count"]
  end

end
