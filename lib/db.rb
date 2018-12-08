require 'sqlite3'

module Tools
  class Db
    class << self
      attr_reader :db

      def create_db
        db = SQLite3::Database.new('db/scraper.sqlite3')
        db.execute <<-SQL
          CREATE TABLE lyrics(
            id integer primary key,
            title varchar(100),
            body varchar(1000),
            image varchar(1000),
            published boolean
          );
        SQL
      end

      def create(data)
        open_db
        record = {
          2 => data[:title],
          3 => data[:body],
          4 => data[:image],
          5 => data[:published]
        }

        db.execute('INSERT INTO lyrics(
          id,
          title,
          body,
          image,
          published
          ) VALUES (?, ?, ?, ?, ?)', record)
      end

      def all
        open_db
        db.results_as_hash = true
        db.execute('SELECT * FROM lyrics')
      end

      def fetch(id)
        open_db
        db.results_as_hash = true
        db.execute('SELECT * FROM lyrics WHERE id = ?', id).flatten
      end

      def unpublished
        open_db
        db.results_as_hash = true
        db.execute('SELECT * FROM lyrics WHERE published = ?', 0).flatten
      end

      def update(id, published)
        open_db
        db.execute('UPDATE lyrics SET published = ? WHERE id = ?', published, id)
      end

      def delete_all
        open_db
        db.execute('DELETE FROM lyrics')
      end

      def open_db
        @db = SQLite3::Database.open('db/scraper.sqlite3')
      end
    end
  end
end
