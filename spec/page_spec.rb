$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'
require 'helper'

describe Localwiki::Client do

  context 'page' do

    before(:all) do
      @site_fetch_json = load_json 'site_fetch.json'
    end

    subject { Localwiki::Client.new 'mockwiki.foo' }

    context "#page_by_name('Luna Park Cafe')" do
      it 'has content matching "amusement park"' do
        response = double('response')
        response.stub(:body) { @site_fetch_json }
        conn = double('conn')
        Faraday.should_receive(:new
          ).with(
            { url: 'mockwiki.foo' }
          ).and_return(conn)
        conn.should_receive(:get
          ).with(
            'http://mockwiki.foo/api/site/1',
            {format: 'json'}
          ).and_return(response)
        response1 = double('response1')
        response1.stub(:body) { load_json 'page_fetch.json' }
        conn.should_receive(:get
          ).with(
            'http://mockwiki.foo/api/page/Luna_Park_Cafe', {format: 'json'}
          ).and_return(response1)
        subject.page_by_name('Luna Park Cafe')['content'].should match(/amusement park/)
      end
    end

  end
end
