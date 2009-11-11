case ENV['RAILS_ENV']
when 'production'
  then
  $global_url = "http://diputadovirtual.heroku.com"
  $paperclip_bucket = "diputado"
when 'staging'
  then
  $global_url = "http://www.diputadovirtualtest.com"
  $paperclip_bucket = "diputado_test"
else
  $global_url = "http://diputado.local"
  $paperclip_bucket = "diputado_dev"
end