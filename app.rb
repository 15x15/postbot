require 'rubygems'
require 'pry'
require 'sqlite3'
require 'sequel'

class App
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def call
    update_database if Lyric.find(published: false).nil?
    send_tweet
  end

  def send_tweet
    record = Lyric.find(published: false)
    TwitterService.send_message record
  end

  def update_database(n = 10)
    n.times do
      data = Scraper.parse
      Lyric.create(
        title: data[:title],
        body: data[:body],
        image: data[:image],
        published: false
      )
      sleep 2
    end
  end

  def self.root
    File.realpath(__dir__)
  end
end

DB = Sequel.connect(
  adapter: :sqlite,
  database: "#{App.root}/db/database.sqlite3"
)
Sequel.extension :migration

Dir[File.join(App.root, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(App.root, 'app', '**', '*.rb')].each { |file| require file }

Sequel::Migrator.run(DB, File.join(App.root, 'db', 'migrations')) if DB

app = App.new
app.call
