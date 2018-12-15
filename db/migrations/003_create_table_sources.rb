class CreateTableSources < Sequel::Migration
  def up
    create_table :sources do
      primary_key :id
      String :provider
      String :url
      Boolean :blocked, default: false
      index :id
    end
  end

  def down
    drop_table :sources
  end
end
