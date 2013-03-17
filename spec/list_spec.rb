require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'listing_test', :record => :new_episodes
    @wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com',
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
    require 'securerandom'
    @pagename = "TestPageForListing#{SecureRandom.uuid}"
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
      VCR.use_cassette 'listing_read_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.read('page', @pagename)
        response["content"].should match(/Created!/)
      end
    end

    it "#update('page', pagename, json) response.status is 204" do
      VCR.use_cassette 'listing_update_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.update('page', @pagename, {content: '<foo>'}.to_json)
        response.status.should eq 204
      end
    end

    it "#list('page') response.to_s should include(TestPageForListing)" do
      VCR.use_cassette 'listing_success' do
        response = @wiki.list('page')
        response.to_s.should include 'TestPageForListing'
      end
    end

    it "#delete('page', pagename) response.status is 204" do
      VCR.use_cassette 'listing_delete_success', :match_requests_on => [:method, @path_matcher] do
        response = @wiki.delete('page', @pagename)
        response.status.should eq 204
      end
    end

    context "when page does not exist" do

      it "#read returns response.status of 404" do
        VCR.use_cassette 'listing_read_fail', :match_requests_on => [:method, @path_matcher] do
          response = @wiki.read('page', @pagename)
          response.status.should eq 404
        end
      end

      it "#delete returns response.status of 404" do
        VCR.use_cassette 'listing_delete_fail', :match_requests_on => [:method, @path_matcher] do
          response = @wiki.delete('page', @pagename)
          response.status.should eq 404
        end
      end

    end
  end
end
