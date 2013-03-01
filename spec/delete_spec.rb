$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'localwiki_client'

describe 'LIVE ec2-54-234-151-52.compute-1.amazonaws.com' do

  subject { Localwiki::Client.new 'ec2-54-234-151-52.compute-1.amazonaws.com', 'NealRodruck', '601c0edda9f7078f3d7cb78c177c54be12afa81a' }

  context '#fetch' do 
  	it 'feches turtles page' do
  		subject.fetch('page', 'turtles').to_s.should include 'Turtles'
  	end	
  end

  context '#delete' do
    it "deletes the bears page" do
      subject.delete('page', 'bears').should eq 204
    end
  end



end