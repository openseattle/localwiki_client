require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'list', :record => :new_episodes
    @wiki = Localwiki::Client.new ENV['localwiki_client_server'],
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
    require 'securerandom'
    @pagename = "TestPageForListing#{SecureRandom.uuid}"
    @wiki.create('page', {name: @pagename, content: "<p>Created List Test Page #{@pagename}!</p>"}.to_json)
  end

  after(:all) do
    VCR.eject_cassette
  end

  context "#list" do

    # resource_type => validation_field
    {'site' => 'language_code',
     'user' => 'first_name',
     'page' => 'name',
     'file' => 'file',
     'map' => 'geom',
     'tag' => 'slug',
     'page_tags' => 'tags'}.each do |resource, field|

      it "#list('#{resource}') returns collection of #{resource} objects" do
        VCR.use_cassette "list_#{resource}_success", :match_requests_on => [:method, :path] do
          @wiki.list(resource).last.should respond_to field.intern
        end
      end

    end

    it "limit parameter limits number of resources returned" do
      VCR.use_cassette 'list_limit_success', :match_requests_on => [:method, :path] do
        response = @wiki.list('page', 3)
        response.length.should eq 3
      end
    end


  end
end