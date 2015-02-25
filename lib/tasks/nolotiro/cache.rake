namespace :nolotiro do
  namespace :cache do
    desc "[nolotiro.org] Clears Rails cache"
    task :clear => :environment do
      Rails.cache.clear
    end
  end
end
