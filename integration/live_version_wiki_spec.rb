$LOAD_PATH.unshift File.expand_path("../../lib/localwiki", __FILE__)
require 'client'

describe 'LIVE seattlewiki.net' do

  subject { Localwiki::Client.new 'seattlewiki.net' }

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').to_s.should include 'Dogs' }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'bears').should include 'Turtles' }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').to_s.should include 'Pigs' }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs')["history_type"].should be_a_kind_of(Numeric) }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').should have_key("history_type") }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').should be_a_kind_of(Numeric) }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').should have_key("history_id") }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs').should_not be_nil }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs',{},true)["objects"][0]["history_id"].should be_a_kind_of(Numeric) }
  end

  context '#fetch' do
    it { subject.search_history('page_version', 'Dogs',{},true)["objects"][0]["history_date"].should be_a_kind_of(Numeric) }
  end

  context '#fetch' do
    it { subject.fetch_version('page_version', 'Dogs',{}).should be_true }
  end



end