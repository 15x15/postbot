require 'rubygems'
require 'pry'
require_relative 'lib/db'
require_relative 'lib/scraper'
require_relative 'lib/twitter_service'

class Program
  attr_reader :options

  def self.run
    new.update_database if Tools::Db.unpublished.empty?
    new.send_tweet
  end

  def initialize(options = {})
    @options = options
  end

  def send_tweet
    data = Tools::Db.unpublished.first
    TwitterService.send_message data
  end

  def update_database(n = 10)
    n.times do
      data = Scraper.parse
      Tools::Db.create data
      sleep 2
    end
  end
end

Program.run
