$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'
require 'helper'

describe 'LocalwikiClient convenience class' do

  context 'initialize' do

    before(:all) do
      @site_fetch_json = load_json 'site_fetch.json'
    end

    before(:each) do
      response = double('response')
      response.stub(:body) { @site_fetch_json }
      conn = double('conn')
      Faraday.should_receive(:new
        ).with(
          { url: 'mockwiki.foo' }
        ).and_return(conn)
      # Faraday::Connection.any_instance
      conn.should_receive(:get
        ).with(
          'http://mockwiki.foo/api/site/1',
          {format: 'json'}
        ).and_return(response)
    end

    subject { LocalwikiClient.new 'mockwiki.foo' }

    context '#site_name' do
      it { subject.site_name.should eq 'Salt Lake Wiki' }
    end

  end
end
