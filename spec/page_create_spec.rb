$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'
require 'helper'

describe Localwiki::Client do

  context 'page create' do

    before(:all) do
      @site_fetch_json = load_json 'site_fetch.json'
    end

    subject { Localwiki::Client.new 'mockwiki.foo', 'wikiuser', 'ab1234ab1324ab1234' }

    context "#create('page', 'A New Page')" do
      it 'response.status is 201' do
        pending 'Need a better test framework'
        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('/api/site/1') { [200, {}, 'egg'] }
          stub.post('/api/page') { [201, {}, 'egg'] }
        end
        subject.create('page', 'A New Page', {}).should eq 'http://mockwiki.foo/A_New_Page'
      end
    end

  end
end
