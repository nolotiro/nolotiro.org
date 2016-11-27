# frozen_string_literal: true

namespace :users do
  desc 'Fixes orphan woeids in users table'
  task fix_orphan_woeids: :environment do
    target = User.joins('left outer join towns on users.woeid = towns.id')
                 .where(towns: { id: nil })

    STDOUT.print <<-MSG.squish
      About to update #{target.size} users to the default woeid. Continue? (y/n)
    MSG

    abort unless STDIN.gets.chomp == 'y'

    target.update_all(woeid: 766_273)
  end
end
