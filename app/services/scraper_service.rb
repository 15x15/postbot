require 'mechanize'

class ScraperService
  class << self
    attr_reader :page

    def parse(provider)
      agent = Mechanize.new
      url = Source.find(provider: provider).url
      @page = agent.get url
      send("create_#{provider}s")
    end

    def create_lyrics
      10.times do
        Lyric.create(
          title: page.css('h2').text,
          body: page.css('#lyric-body-text').text,
          image: page.css('#featured-artist-avatar img').attribute('src').value
        )
        sleep 1
      end
    end

    def create_quotes
      page.css('.clearfix').each do |data|
        Quote.create(
          author: data.css('.bq-aut').text,
          text: data.css('.b-qt').text
        )
      end
    end
  end
end
