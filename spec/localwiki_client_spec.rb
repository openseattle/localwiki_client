require File.expand_path("../helper", __FILE__)

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'localwiki_client', :record => :new_episodes
    @wiki = Localwiki::Client.new ENV['localwiki_client_server']
  end

  after(:all) do
    VCR.eject_cassette
  end

  context 'attributes' do

    context '#name' do
      it { @wiki.site.name.should eq 'example.com' }
    end

    context '#time_zone' do
      it { @wiki.site.time_zone.should eq 'America/Chicago' }
    end

    context '#language_code' do
      it { @wiki.site.language_code.should eq 'en-us' }
    end

    %W{site page user file map tag page_tags}.each do |resource|
      context "#count(#{resource})" do
        it { @wiki.count(resource).should be_a Fixnum }
      end
    end

  end
end
