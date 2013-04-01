require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'fetch', :record => :new_episodes
    @wiki = Localwiki::Client.new ENV['localwiki_client_server'],
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
    require 'securerandom'
  end

  after(:all) do
    VCR.eject_cassette
  end

  context "#fetch_version" do

    it "returns json that includes all edits" do
      pagename = "TestPage#{SecureRandom.uuid}"
      VCR.use_cassette 'basic_fetch_version_success', :match_requests_on => [:method] do
        @wiki.create('page', {name: pagename, content: '<p>Created!</p>'}.to_json)
        @wiki.update('page', pagename, {content: '<p>foo</p>'}.to_json)
        response = @wiki.fetch_version('page', pagename)
        response['meta']['total_count'].should eq 2
      end
    end
  end

  context "#unique_authors" do

    it "returns the number of authors" do
      pagename = "TestPage#{SecureRandom.uuid}"
      VCR.use_cassette 'basic_unique_authors_success', :match_requests_on => [:method] do
        @wiki.create('page', {name: pagename, content: '<p>Created!</p>'}.to_json)
        @wiki.update('page', pagename, {content: '<p>foo</p>'}.to_json)
        @wiki.unique_authors('page', pagename).should eq 1
      end
    end

  end
end

