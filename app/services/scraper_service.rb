require 'mechanize'

class ScraperService
  class << self
    attr_reader :page

    def parse(provider)
      agent = Mechanize.new
      url = Source.find(provider: provider).url
      @page = agent.get url
      send("build_#{provider}")
    end

    def build_lyric
      {
        title: page.css('h2').text,
        body: page.css('#lyric-body-text').text,
        image: page.css('#featured-artist-avatar img').attribute('src').value
      }
    end
  end
end
