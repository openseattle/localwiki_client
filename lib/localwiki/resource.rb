require 'ostruct'

module Localwiki

  ##
  # create instance (of correct type) for resource
  # @param type resource type "regions", "pages", "users", "files", "maps", "tags", "page_tags"
  # @param json_hash [Hash] hash object from parsed json
  # @return new instance - child class of Localwiki::Resource
  def self.make_one(type, json_hash)
    klass_name = type.to_s.split('_').map {|s|s.capitalize}.join
    Object.const_get('Localwiki').const_get(klass_name).new(json_hash)
  end

  ##
  # simple OpenStruct object to allow attribute access on resources (instead of hash key access)
  class Resource < OpenStruct

    # raw json string used to instanciate object
    attr_reader :json

    ##
    # create instance of resource
    # @param [Hash] json_hash hash object from parsed json
    def initialize json_hash
      @json = json_hash
      super
    end
  end

  class Regions < Resource; end

  # http://localwiki.readthedocs.org/en/latest/api.html#site
  #class Site < Resource; end

  # http://localwiki.readthedocs.org/en/latest/api.html#pages
  class Pages < Resource; end

  ##
  # represents map object returned from server
  # http://localwiki.readthedocs.org/en/latest/api.html#maps
  class Maps < Resource

    def single_point?
      self.points && self.points['coordinates'].size == 1
    end

    def line?
      self.lines
    end

    def poly?
      self.polys
    end

    def lat
      self.points['coordinates'].first[0] if self.single_point?
    end

    def long
      self.points['coordinates'].first[1] if self.single_point?
    end

  end

  # http://localwiki.readthedocs.org/en/latest/api.html#files
  class Files < Resource; end

  # http://localwiki.readthedocs.org/en/latest/api.html#tags
  class Tags < Resource; end

  # http://localwiki.readthedocs.org/en/latest/api.html#page-tags
  class PageTags < Resource; end

  # http://localwiki.readthedocs.org/en/latest/api.html#users
  class Users < Resource; end

end
