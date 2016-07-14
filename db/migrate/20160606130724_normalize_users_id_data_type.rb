# frozen_string_literal: true
class NormalizeUsersIdDataType < ActiveRecord::Migration
  def up
    execute <<-SQL.squish
      ALTER TABLE users MODIFY id INT(11) NOT NULL AUTO_INCREMENT
    SQL
  end

  def down
    execute <<-SQL.squish
      ALTER TABLE users MODIFY id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT
    SQL
  end
end
