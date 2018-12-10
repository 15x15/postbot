class CreateTableLyrics < Sequel::Migration
  def up
    create_table :lyrics do
      primary_key :id
      String :title
      String :body
      String :image
      Boolean :published
      index :id
    end
  end

  def down
    drop_table :lyrics
  end
end
