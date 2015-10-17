class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration

  UTF8_PAIRS = {
    'mailboxer_notifications' => 'body'
  }

  def change
    execute "ALTER DATABASE `#{ActiveRecord::Base.connection.current_database}` CHARACTER SET utf8mb4;"

    ActiveRecord::Base.connection.tables.each do |table|
      execute "ALTER TABLE `#{table}` CHARACTER SET = utf8mb4;"
    end

    UTF8_PAIRS.each do |table, col|
      execute "ALTER TABLE `#{table}` CHANGE `#{col}` `#{col}` TEXT  CHARACTER SET utf8mb4  NULL;"
    end
  end
end
