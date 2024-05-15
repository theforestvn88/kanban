namespace :cypress do
    desc "open cypress with configs"
    task start: :environment do
        ENV["RAILS_ENV"] = "test"
        ENV["CYPRESS_RAILS_PORT"] = "3000"
        ENV["CYPRESS_RAILS_TRANSACTIONAL_SERVER"] = "true"
        Rake::Task["cypress:open"].invoke 
    end
end