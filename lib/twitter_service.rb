require 'twitter'
require_relative '../config/secrets'
require_relative '../lib/images'

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

    def send_message(data)
      if data['image']
        file = Tools::Images.temp_file data['image']
        client.update_with_media(data['body'][0...280], open(file))
        File.delete file
      else
        client.update(data['body'])
      end
      Tools::Db.update(data['id'], 1)
    end
  end
end
