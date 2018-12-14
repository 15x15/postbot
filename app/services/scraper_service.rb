require 'mechanize'

class ScraperService
  URL = 'https://www.lyrics.com/lyric/random'.freeze

  def self.parse
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
