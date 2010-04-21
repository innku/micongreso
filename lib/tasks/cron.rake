task :cron => :environment do
  require 'heroku'
  if Delayed::Job.count == 0
    heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
    heroku.set_workers("diputadovirtual", 0)
  end
end