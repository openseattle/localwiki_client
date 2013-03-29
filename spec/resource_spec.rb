$LOAD_PATH.unshift File.expand_path("../../lib/localwiki", __FILE__)
require 'resource'
require 'json'

describe 'Localwiki' do

  context 'Resource' do

    context "instance" do

      it "accepts and stores json" do
        resource = Localwiki::Resource.new({my_key: 'my_value'})
        resource.json.should eq({:my_key => "my_value"})
      end

      it "responds with values when sent messages that match keys" do
        resource = Localwiki::Resource.new({my_key: 'my_value'})
        resource.my_key.should eq 'my_value'
      end

      it "responds with nil when sent messages that don't match keys" do
        resource = Localwiki::Resource.new({my_key: 'my_value'})
        resource.my_key.should eq 'my_value'
      end

    end
  end

  context '::Page' do

    context "instance" do

      before(:all) do
        json = %@{
                "content": "<p>Bradfordville Blues Club experience is like no other. It combines a truly unique location and atmosphere with the best the Blues has to offer. </p>",
                "id": 158,
                "map": "/api/map/Bradfordville_Blues_Club",
                "name": "Bradfordville Blues Club",
                "page_tags": "/api/page_tags/Bradfordville_Blues_Club",
                "resource_uri": "/api/page/Bradfordville_Blues_Club",
                "slug": "bradfordville blues club"
            }@
        @page = Localwiki::Page.new(JSON.parse(json))
      end

      it "#id is correct" do
        @page.id.should eq 158
      end

      it "#resource_uri is correct" do
        @page.resource_uri.should eq "/api/page/Bradfordville_Blues_Club"
      end

      it "#slug is correct" do
        @page.slug.should eq "bradfordville blues club"
      end

    end
  end
end
