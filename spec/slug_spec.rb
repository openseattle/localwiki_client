require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'slug', :record => :new_episodes
    @wiki = Localwiki::Client.new ENV['localwiki_client_server'],
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
  end

  after(:all) do
    VCR.eject_cassette
  end

  context '#slugify' do

    it 'handles spaces' do
      @wiki.send(:slugify, 'Hello World').should eq 'Hello_World'
    end

  end
end



