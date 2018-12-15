class CreateTableQuotes < Sequel::Migration
  def up
    create_table :quotes do
      primary_key :id
      String :author
      String :text
      Boolean :published, default: false
      index :id
    end
  end

  def down
    drop_table :quotes
  end
end
