class AddReadedCountToAd < ActiveRecord::Migration
  def up
    add_column :ads, :readed_count, :integer
    connection = ActiveRecord::Base.connection
    query = ActiveRecord::Base.connection.execute("SELECT * FROM readedAdCount")
    query.each do |row|
      # find_by_id doesn't raise ActiveRecord::RecordNotFound
      ad = Ad.find_by_id(row[0])
      unless ad.nil? 
        ad.readed_count = row[1]
        ad.save
      end
    end
    drop_table "readedAdCount"
  end

  def down
    remove_column :ads, :readed_count, :integer
    # TODO: move everything back to readedAdCount table
    # +---------+---------------------------+------+-----+---------+-------+
    # | Field   | Type                      | Null | Key | Default | Extra |
    # +---------+---------------------------+------+-----+---------+-------+
    # | id_ad   | int(11)                   | NO   | PRI | NULL    |       |
    # | counter | int(11) unsigned zerofill | NO   |     | NULL    |       |
    # +---------+---------------------------+------+-----+---------+-------+
  end
end
