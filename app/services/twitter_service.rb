require 'twitter'
require_relative '../../config/secrets'
require_relative '../services/images_service'

class TwitterService
  class << self
    def client
      client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
      end
    end

    def send_message(record)
      case record.class
      when Lyric
        file = ImagesService.temp_file record.image
        client.update_with_media(record.body[0...280], open(file))
        File.delete file
      when Quote
        client.update(record.text + record.author)
      end
      record.update(published: true)
    end
  end
end
