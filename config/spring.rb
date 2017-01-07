# frozen_string_literal: true

%w(
  .ruby-version
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }
