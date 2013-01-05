$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'
require 'rspec/mocks'

describe 'LocalwikiClient' do

  context 'Site details' do
    subject { LocalwikiClient.new 'mockwiki.foo' }

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

    it {should respond_to :hostname}
    it {should respond_to :site_name}
    it {should respond_to :currently_online?}
    it {should respond_to :time_zone}
    it {should respond_to :language_code}
    it {should respond_to :total_resources}
    it {should respond_to :page_by_name}

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
                 :url => 'http://mockwiki.foo/api/user?limit=1&format=json',
                 :timeout => 120}
            ).and_return(response)
          subject.total_resources('user').should eq 6
        end
      end

      context "#page_by_name('Luna Park Cafe')" do
        it 'has content matching "amusement park"' do
          response = double('response')
          response.stub(:body) {
            %q[{"content": "<p>\n\t </p>\n<table class=\"details\">\n\t<tbody>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Location</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<p>\n\t\t\t\t\t2918 Southwest Avalon Way</p>\n\t\t\t\t<p>\n\t\t\t\t\tSeattle, WA 98126</p>\n\t\t\t</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Hours</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t7am - 10pm Everyday</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Phone</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t(206) 935-7250</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Website</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<a href=\"http://www.lunaparkcafe.com/\">lunaparkcafe.com</a></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Established</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\tMarch 18th, 1989</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Price range</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t$10</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Payment Methods</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\tCash, credit cards</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td style=\"background-color: rgb(232, 236, 239);\">\n\t\t\t\t<strong>Wheelchair accessibility</strong></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\tNo stairs.</td>\n\t\t</tr>\n\t</tbody>\n</table>\n<p>\n\tFantastic diner filled with historic references to the Luna Park amusement park.</p>\n<p>\n\t<span class=\"image_frame image_frame_border\"><img src=\"_files/luna_park_cafe_front.jpg\" style=\"width: 300px; height: 225px;\"></span><span class=\"image_frame image_frame_border\"><img src=\"_files/luna_park_cafe_batmobile_ride.jpg\" style=\"width: 300px; height: 225px;\"></span></p>\n<h3>\n\tRelated Links</h3>\n<ul>\n\t<li>\n\t\t<a href=\"Restaurants\">Restaurants</a></li>\n</ul>\n<p>\n\t </p>\n", "id": 572, "map": "/api/map/Luna_Park_Cafe", "name": "Luna Park Cafe", "page_tags": "/api/page_tags/Luna_Park_Cafe", "resource_uri": "/api/page/Luna_Park_Cafe", "slug": "luna park cafe"}]
          }
          RestClient::Request.should_receive(:execute
            ).with(
              {:method => :get,
               :url => 'http://mockwiki.foo/api/page/Luna_Park_Cafe?limit=0&format=json',
               :timeout => 120}
            ).and_return(response)
          subject.page_by_name('Luna Park Cafe')['content'].should match(/amusement park/)
        end
      end

      it '#currently_online?' do
        RestClient::Request.should_receive(:execute
          ).with(
              {:method => :get,
               :url => 'mockwiki.foo',
               :headers=>{}}
          ).and_return("")
        LocalwikiClient.new('mockwiki.foo').should be_currently_online
      end
    end
  end
end
