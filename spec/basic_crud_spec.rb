$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require File.expand_path("../helper", __FILE__)
require 'localwiki_client'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  # c.debug_logger = File.open('spec/fixtures/cassettes/debug_vcr.log', 'w')
end


describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'basic_crud', :record => :new_episodes
    @wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com',
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
    require 'securerandom'
    @pagename = "TestPage#{SecureRandom.uuid}"
    @path_matcher = lambda do |request_1, request_2|
      URI(request_1.uri).path.match(/TestPage/) && URI(request_2.uri).path.match(/TestPage/)
    end
  end

  after(:all) do
    VCR.eject_cassette
  end

  context "CRUD method" do

    it "#create('page', json) response.status is 201" do
      response = @wiki.create('page', {name: @pagename, content: '<p>Created!</p>'}.to_json)
      response.status.should eq 201
    end

    it "#read('page', pagename) response.status should match(/Created!/)" do
      VCR.use_cassette 'basic_crud_read_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.read('page', @pagename)
        response["content"].should match(/Created!/)
      end
    end

    it "#update('page', pagename, json) response.status is 204" do
      VCR.use_cassette 'basic_crud_update_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.update('page', @pagename, {content: '<foo>'}.to_json)
        response.status.should eq 204
      end
    end

    it "#delete('page', pagename) response.status is 204" do
      VCR.use_cassette 'basic_crud_delete_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.delete('page', @pagename)
        response.status.should eq 204
      end
    end

  end
end
