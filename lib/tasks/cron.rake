task :cron => :environment do
  require 'heroku'
  puts "Entering cron"
  if Delayed::Job.count == 0
    puts "Opening heroku"
    heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
    puts "Setting workers to 0"
    heroku.set_workers("diputadovirtual", 0)
  end
end