require 'localwiki_client'

##
# Written by Seth Vincent, Brandon Faloona
#
# LocalWiki API doc:
# localwiki.readthedocs.org/en/latest/api.html

localwikis = [
                'wikislo.org',
                'miamiwiki.org',
                'oaklandwiki.org',
                'saltlakewiki.org',
                'seattlewiki.net',
                'cuwiki.net',
                'conway.localwiki.org',
                'viget.org',
                'olywiki.org',
                'www.bmorepipeline.org',
                'wikikc.com',
                'toledowiki.net',
                'arborwiki.org',
                'oshima-gdm.jp',
                'dentonwiki.org',
                'trianglewiki.org',
                'scruzwiki.org',
                'boise.localwiki.org',
                'antarctica.localwiki.org',
                'sacwiki.org',
                'denver-wiki.org',
                'tacoma.localwiki.org',
                'denver-wiki.org',
                'taswiki.net',
                'barkerwiki.org.au',
                'sydney.localwiki.org',
                'southshorewiki.ca',
                'toronto.localwiki.org',
                'sfwiki.org',
                'www.sdwiki.org',
                'www.wikiofgoodliving.org',
                'chicowiki.org',
                'foothills.localwiki.org',
                'www.newbritainwiki.org',
                'www.gainesvillewiki.org',
                'www.tallahasseewiki.org',
                'decorahwiki.org',
                'cantonwiki.org',
                'detroitwiki.org',
                'wiki.betteralamance.org',
                'wikikc.org',
                'twincitieswiki.org',
                'porttownsendwiki.org',
                'austin.localwiki.org',
                'www.mac-wiki.org',
                'tulsawiki.org',
                'districtcommons.org',
                'www.utkalen.se',
                'www.nquarter.co.uk',
                'hyderabadwiki.com',
                'sissachwiki.ch',
                'www.kingslynnwiki.co.uk',
                'bermudawiki.org'
              ]

def get_wiki_stats(base_url)

  wiki = LocalwikiClient.new base_url
  site_thread = Thread.current
  site_thread[:output] = []

  wiki_name = wiki.site.name << "\n"

  resource_types = ['page', 'user', 'file', 'map']
  resource_types.collect do |resource|
    label = "  #{resource.to_s}s: "
    site_thread[:output].push "#{label[0..7]} #{wiki.count(resource).to_s.rjust(6)}"
  end

  site_thread[:output].sort!.reverse!
  puts wiki_name << site_thread[:output].join("\n")

end

# for each localwiki, create a thread to collect and print stats
site_threads = localwikis.collect do |wiki|

  Thread.new do
    begin

      sleep 0.05
      get_wiki_stats(wiki)

    rescue Errno::ETIMEDOUT => timeout
      puts "#{wiki} timed out."
    rescue => e
      puts "#{wiki} returned the error: #{e.message}"
    end
  end
end

puts "Collecting stats on #{site_threads.count} wikis ..."
site_threads.collect &:join
