$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'localwiki_client'

describe 'LIVE ec2-54-234-151-52.compute-1.amazonaws.com' do

  subject { Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com', 'NealRodruck', '601c0edda9f7078f3d7cb78c177c54be12afa81a' }

  context '#fetch_version' do
    it "#fetch_version() example == (control + 1)" do 
        example = subject.fetch_version('page_version', 'Dogs')["objects"].length + 1              
        subject.update('page', 'Dogs', {content: '<foo>'}.to_json)
        subject.fetch_version('page_version', 'Dogs')["objects"].length.should eq example 
    end

    it "#fetch_version number" do
      subject.fetch_version('page_version', 'Dogs')["objects"].length.should be_a_kind_of Numeric
    end  

    it"#fetch_version has" do
      subject.fetch_version('page_version', 'Dogs')["objects"].should be_a_kind_of Array
    end  
  end

  context '#delete' do

    it "deletes the bears page" do
      subject.create('page', {name: 'bears', content: '<p>For delete rspec</p>'}.to_json)
      subject.delete('page', 'bears').should eq 'URL removed: http://ec2-54-234-151-52.compute-1.amazonaws.com/api/page/bears'
    end

    it "returns error message if site unfound" do
      subject.delete('page', 'blahblah').should eq 'URL not found: http://ec2-54-234-151-52.compute-1.amazonaws.com/api/page/blahblah'
    end
  end   
end