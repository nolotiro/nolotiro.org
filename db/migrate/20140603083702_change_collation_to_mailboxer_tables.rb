class ChangeCollationToMailboxerTables < ActiveRecord::Migration

  def change_to_utf8(table_name)
     execute("ALTER TABLE #{table_name} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;")
     execute("ALTER TABLE #{table_name} CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;")
  end

  def change_to_latin1(table_name)
     execute("ALTER TABLE #{table_name} DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;")
     execute("ALTER TABLE #{table_name} CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci ;")
  end

  def up
    change_to_utf8('receipts')
    change_to_utf8('notifications')
    change_to_utf8('conversations')
  end

  def down
    change_to_latin1('receipts')
    change_to_latin1('notifications')
    change_to_latin1('conversations')
  end

end
