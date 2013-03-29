require File.expand_path("../helper", __FILE__)

describe 'LIVE saltlakewiki.org' do

  subject { Localwiki::Client.new 'saltlakewiki.org' }

  context '#time_zone' do
    it {subject.site.time_zone.should eq 'America/Chicago' }
  end

  context '#language_code' do
    it {subject.site.language_code.should eq 'en-us'}
  end

  context '#total_resources("user")' do
    it {subject.count('user').to_i.should > 2}
  end

end

