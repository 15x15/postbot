require "rubygems"
require "mechanize"
require "sqlite3"

class Scraper
  attr :url

  def call
    data = parse
    #write_db(data)
    write_file(data)
  end

  def initialize(url = nil)
    @url = url || ""
  end
  
  def parse
    agent = Mechanize.new
    page = agent.get url
    song = { title: page.css("h2").text, body: page.css("#lyric-body-text").text }
  end
  
  def write_file(data)
    name = data[:title].downcase.gsub!(" ", "_").gsub!(/[^0-9A-Za-z_]/, "")  
    File.write("./files/#{name}.json", data)
  end
  
  def create_db
    db = SQLite3::Database.new("scraper.db")
    rows = db.execute <<-SQL 
             create table lyrics(
               id int,
               title varchar(100),
               body varchar(1000)
             );
           SQL
  end
  
  def write_db(data)
    db = SQLite3::Database.open("scraper.db")
    records = { 2 => data[:title], 3 => data[:body] }
    
    records.each do |record|
      db.execute("INSERT INTO lyrics(id, title, body) VALUES(?, ?, ?)", record)  
    end
  end
end

url = "https://www.lyrics.com/lyric/random"
10.times { Scraper.new(url).call }
