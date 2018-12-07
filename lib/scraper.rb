require 'mechanize'

class Scraper
  class << self
    include Dbtools

    attr_reader :url

    URL = 'https://www.lyrics.com/lyric/random'.freeze

    def call
      Dbtools.create parse_data
    end

    def parse_data
      agent = Mechanize.new
      page = agent.get URL
      {
        title: page.css('h2').text,
        body: page.css('#lyric-body-text').text,
        image: page.css('#featured-artist-avatar img').attribute('src').value,
        published: 0
      }
    end
  end
end
