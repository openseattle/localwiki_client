require File.expand_path("../helper", __FILE__)

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("fixtures/cassettes", File.dirname(__FILE__))
  c.hook_into :webmock
  # c.debug_logger = File.open('spec/fixtures/cassettes/debug_vcr.log', 'w')
end

describe 'LocalwikiClient' do

  before(:all) do
    VCR.insert_cassette 'localwiki_client', :record => :new_episodes
    @wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com'
  end

  after(:all) do
    VCR.eject_cassette
  end

  context 'attributes' do

    context '#site_name' do
      it { @wiki.site_name.should eq 'example.com' }
    end

    context '#time_zone' do
      it { @wiki.time_zone.should eq 'America/Chicago' }
    end

    context '#language_code' do
      it { @wiki.language_code.should eq 'en-us' }
    end

    context '#page_by_name' do
      it 'returns page body'
    end

    context '#count(resource)' do
      it { @wiki.count('site').should be_a Fixnum }
      it { @wiki.count('page').should be_a Fixnum }
      it { @wiki.count('user').should be_a Fixnum }
      it { @wiki.count('file').should be_a Fixnum }
      it { @wiki.count('map').should be_a Fixnum }
      it { @wiki.count('tag').should be_a Fixnum }
      it { @wiki.count('page_tags').should be_a Fixnum }
    end

    context '#list' do
      it 'returns list of items matching'
    end

  end
end
