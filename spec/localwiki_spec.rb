$LOAD_PATH.unshift File.expand_path("../../lib/localwiki", __FILE__)
require 'resource'

describe 'Localwiki' do

  context 'methods' do

    context '::make_one' do

      it "creates instance of specified resource from json" do
        page = Localwiki::make_one(:page, {name: 'a page', id: '34'})
        page.class.should be Localwiki::Page
      end

    end
  end
end