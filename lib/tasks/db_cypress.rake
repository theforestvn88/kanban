namespace :db do
  namespace :cypress do
    desc "seed data for cypress"
    task seed: :environment do
      load(Rails.root.join("lib/cypress_rails/db_seed.rb"))
    end
  end
end

