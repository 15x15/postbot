require 'rubygems'
require 'pry'
require 'sqlite3'
require 'sequel'

class App
  attr_reader :provider, :model

  def initialize(options: {})
    @provider = options[:provider] || 'quote'
    @model = Kernel.const_get(provider.capitalize)
  end

  def call
    ScraperService.parse(provider) if model.find(published: false).nil?
    post_message
  end

  def post_message
    record = model.find(published: false)
    TwitterService.send_message record
  rescue StandardError
    record.update(published: true)
    retry
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

Dir[File.join(App.root, 'app', '**', '*.rb')].each { |file| require file }

Sequel::Migrator.run(DB, File.join(App.root, 'db', 'migrations')) if DB
