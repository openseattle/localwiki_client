require File.expand_path("../helper", __FILE__)

describe 'LIVE testwiki instance' do

  before(:all) do
    @wiki = Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com',
                                  ENV['localwiki_client_user'],
                                  ENV['localwiki_client_apikey']
  end

  if test_env_vars_set?

    context "CRUD methods" do

      before(:all) do
        require 'securerandom'
        @pagename = "TestPage#{SecureRandom.uuid}"
        json = {name: @pagename, content: '<p>Created!</p>'}.to_json
        @create_response = @wiki.create('page', json)
      end

      it "#create('page', json) response.status is 201" do
        @create_response.status.should eq 201
      end

      it "#read('page', 'TestPage<uuid>') response.status is 200" do
        response = @wiki.read('page', @pagename)
        response["content"].should match(/Created!/)
      end

      it "#update('page', 'TestPage<uuid>', json) response.status is 204" do
        json = {content: '<p>Updated!</p>'}.to_json
        response = @wiki.update('page', @pagename, json)
        response.status.should eq 204
        @wiki.read('page', @pagename)["content"].should match(/Updated!/)
      end

      it "#delete('page', 'TestPage<uuid>') response.status is 204" do
        response = @wiki.delete('page', @pagename)
        response.status.should eq 204
        @wiki.read('page', @pagename).status.should eq 404
      end

    end
  end

  context "#list" do

    before(:all) do
      @response = @wiki.list('page', 2)
    end

    it "returns collection of resources objects" do
      @response.first.class.superclass.should eq Localwiki::Resource
    end

    it "limit parameter limits number of resources returned" do
      @response.length.should eq 2
    end

  end
end