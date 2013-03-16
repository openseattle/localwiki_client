require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  context "#create and #page_by_name" do

    before(:all) do
      VCR.insert_cassette 'basic', :record => :new_episodes
      @wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com',
                                    ENV['localwiki_client_user'],
                                    ENV['localwiki_client_apikey']
    end

    after(:all) do
      VCR.eject_cassette
    end

    it "handle spaces" do
      require 'securerandom'
      base_name = "Test Page"
      page_name = "#{base_name}#{SecureRandom.uuid}"
      path_matcher = lambda do |request_1, request_2|
        URI(request_1.uri).path.match(/Test/) && URI(request_2.uri).path.match(/Test/)
      end
      @wiki.create('page', {name: page_name, content: '<p>Created page with spaces!</p>'}.to_json)
      VCR.use_cassette 'basic_page_by_name_spaces', :match_requests_on => [:method, path_matcher] do
        response = @wiki.page_by_name(page_name)
        response["content"].should match(/Created page with spaces!/)
      end
    end

  end

end
