$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'localwiki_client'

describe 'LIVE saltlakewiki.org' do

  subject { Localwiki::Client.new 'saltlakewiki.org' }

  context '#time_zone' do
    it {subject.time_zone.should eq 'America/Chicago' }
  end

  context '#language_code' do
    it {subject.language_code.should eq 'en-us'}
  end

  context '#total_resources("user")' do
    it {subject.count('user').to_i.should > 2}
  end

end
