# frozen_string_literal: true
module Phantomjs
  extend self

  def check
    extract unless extracted?
  end

  def path
    Rails.root.join('bin', 'phantomjs').to_s
  end

  def extracted?
    File.exist?(path)
  end

  def extract
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        command = "tar -xvf #{compressed_path} #{source_path}"
        raise "Failed to execute '#{command}'" unless system(command)

        FileUtils.mv(source_path, path)
      end
    end
  end

  private

  def source_path
    File.join(compressed_basename, 'bin', 'phantomjs')
  end

  def compressed_basename
    'phantomjs-2.1.1-linux-x86_64'
  end

  def compressed_fullname
    "#{compressed_basename}.tar.bz2"
  end

  def compressed_path
    Rails.root.join('vendor', 'phantomjs', compressed_fullname)
  end
end
