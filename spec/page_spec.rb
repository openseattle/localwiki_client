$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'
require 'helper'

describe Localwiki::Client do

  context 'page' do

    before(:all) do
      @site_fetch_json = load_json 'site_fetch.json'
    end

    before(:each) do
      response = double('response')
      response.stub(:body) { @site_fetch_json }
      RestClient::Request.stub(:execute) { response }
    end

    subject { Localwiki::Client.new 'mockwiki.foo' }

    context "#page_by_name('Luna Park Cafe')" do
      it 'has content matching "amusement park"' do
        response = double('response')
        response.stub(:body) { load_json 'page_fetch.json' }
        RestClient::Request.should_receive(:execute
          ).with(
            {:method => :get,
             :url => 'http://mockwiki.foo/api/page/Luna_Park_Cafe?format=json',
             :timeout => 120}
          ).and_return(response)
        subject.page_by_name('Luna Park Cafe')['content'].should match(/amusement park/)
      end
    end

  end
end
