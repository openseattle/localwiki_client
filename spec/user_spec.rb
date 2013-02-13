$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'
require 'helper'

describe Localwiki::Client do

  context 'user' do

    before(:all) do
      @site_fetch_json = load_json 'site_fetch.json'
    end

    before(:each) do
      response = double('response')
      response.stub(:body) { @site_fetch_json }
      RestClient::Request.stub(:execute) { response }
    end

    subject { Localwiki::Client.new 'mockwiki.foo' }

    context '#total_resources("user")' do
      it 'should eq 6' do
        response = double('response')
        response.stub(:body) { load_json 'user_list.json' }
        RestClient::Request.should_receive(:execute
          ).with(
              {:method => :get,
               :url => 'http://mockwiki.foo/api/user?limit=1&format=json',
               :timeout => 120}
          ).and_return(response)
        subject.count('user').should eq 6
      end
    end

  end
end
