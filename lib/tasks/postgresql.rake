# frozen_string_literal: true

#
# Tasks for taking & restoring db snapshots
#
namespace :db do
  desc "Dumps the database to a file."
  task dump: :environment do
    cmd = <<-SHELL.squish
      pg_dump \
        --no-acl \
        --no-owner \
        --format c \
        --username #{config[:username]} \
        #{config[:database]} > #{backup_name}
    SHELL

    puts "Dumping #{Rails.env} database..."

    run_with_pgpass(cmd)
  end

  desc "Restores database from a file."
  task restore: :environment do
    cmd = <<-SHELL.squish
      pg_restore \
        --clean \
        --dbname #{config[:database]} \
        --no-acl \
        --no-owner \
        --username #{config[:username]} \
        #{backup_name}
    SHELL

    puts "Restoring #{Rails.env} database..."

    run_with_pgpass(cmd)
  end

  private

  def run_with_pgpass(cmd)
    old_content = File.read(pgpass_path) if File.exist?(pgpass_path)

    create_pgpass("*:*:*:*:#{config[:password]}")

    raise unless system(cmd)
  ensure
    old_content ? create_pgpass(old_content) : File.delete(pgpass_path)
  end

  def create_pgpass(content)
    File.open(pgpass_path, "w", 0o600) { |f| f.write(content) }
  end

  def pgpass_path
    File.join(Dir.home, ".pgpass")
  end

  def backup_name
    name = ENV["BACKUP_NAME"]

    raise "Please specificy BACKUP_NAME" if name.blank?

    Rails.root.join("db", "#{name}.dump")
  end

  def config
    @config ||= ActiveRecord::Base.connection_config
  end
end
