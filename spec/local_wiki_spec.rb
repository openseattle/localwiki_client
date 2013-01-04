require_relative '../lib/local_wiki'
require 'rspec/mocks'

describe 'LocalWiki' do

  context 'Site details' do
    subject { LocalWiki.new 'mockwiki.foo' }

    before(:each) do
      response = double('response')
      response.stub(:body) {
        %q[{"domain": "mockwiki.foo", "id": 1, "language_code": "en-us", "license": "<p>Except where otherwise noted, this content is licensed under a <a rel=\" license\" href=\"http://creativecommons.org/licenses/by/3.0/\">Creative Commons Attribution License</a>. See <a href=\"/Copyrights\">Copyrights.</p>", "name": "Salt Lake Wiki", "resource_uri": "/api/site/1", "signup_tos": "I agree to release my contributions under the <a rel=\"license\" href=\"http://creativecommons.org/licenses/by/3.0/\" target=\"_blank\">Creative Commons-By license</a>, unless noted otherwise. See <a href=\"/Copyrights\" target=\"_blank\">Copyrights</a>.","time_zone": "America/Chicago"}]
      }
      RestClient::Request.should_receive(:execute
        ).with(
          {:method => :get,
           :url => 'http://mockwiki.foo/api/site/1?limit=0&format=json',
           :timeout => 120}
        ).and_return(response)
    end

    it {should respond_to :base_url}
    it {should respond_to :site_name}
    it {should respond_to :currently_online?}
    it {should respond_to :time_zone}
    it {should respond_to :language_code}
    it {should respond_to :total_resources}

    context 'mockwiki.foo' do
      context '#time_zone' do
        it {subject.time_zone.should eq 'America/Chicago' }
      end
      context '#language_code' do
        it {subject.language_code.should eq 'en-us'}
      end
      context '#total_resources("user")' do
        it 'should eq 6' do
          response = double('response')
          response.stub(:body) {
            %q<{"meta": {"limit": 0, "offset": 0, "total_count": 6}, "objects": [{"date_joined": "2012-10-05T21:12:34.103559", "first_name": "", "last_name": "", "resource_uri": "", "username": "AnonymousUser"}, {"date_joined": "2012-11-02T15:24:44.621040", "first_name": "Kris", "last_name": "Trujillo", "resource_uri": "/api/user/3", "username": "kristrujillo"}, {"date_joined": "2012-10-17T14:01:40.778496", "first_name": "Tod", "last_name": "Robbins", "resource_uri": "/api/user/2", "username": "todrobbins"}, {"date_joined": "2012-11-20T21:47:33.152069", "first_name": "Jessie", "last_name": "", "resource_uri": "/api/user/4", "username": "jessiepech"}, {"date_joined": "2012-10-05T21:12:33", "first_name": "Andrew", "last_name": "Sullivan", "resource_uri": "/api/user/1", "username": "licyeus"}, {"date_joined": "2012-12-08T15:33:29.251275", "first_name": "Ryan", "last_name": "", "resource_uri": "/api/user/5", "username": "saltlakeryan"}]}>
          }
          RestClient::Request.should_receive(:execute
            ).with(
                {:method => :get,
                 :url => 'http://mockwiki.foo/api/user?limit=0&format=json',
                 :timeout => 120}
            ).and_return(response)
          #LocalWiki.new('mockwiki.foo').
          subject.total_resources('user').should eq 6
        end
      end
      it '#currently_online?' do
        RestClient::Request.should_receive(:execute
          ).with(
              {:method => :get,
               :url => 'mockwiki.foo',
               :headers=>{}}
          ).and_return("")
        LocalWiki.new('mockwiki.foo').should be_currently_online
      end
    end
  end
end
