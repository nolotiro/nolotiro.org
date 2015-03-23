namespace :nolotiro do 
  desc "[nolotiro] Remember all the users to log in with the token. After all the migration to v3  - they are 13500 users that can't log in because they are not confirmed in this moment (20131226)"
  task :confirmation_reminder => :environment do
    User.where(:confirmed_at => nil).each do |user|
      UserMailer.confirmation_reminder(user).deliver
    end
  end

end
