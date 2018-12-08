require 'twitter'
require './config/figaro'

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
      client.update(data['title'])
      Tools::Db.update(data['id'], 1)
      #client.update_with_media(data['title'], open(data['image']))
    end
  end
end
