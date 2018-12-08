require 'rubygems'
require 'irbtools'
require 'pry'
require_relative 'lib/db'
require_relative 'lib/scraper'
require_relative 'lib/twitter_service'

class Program
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def send_tweet
    data = Tools::Db.unpublished.first
    TwitterService.send_message data
  end

  def update_database
    data = Scraper.parse
    Tools::Db.create data
  end
end
