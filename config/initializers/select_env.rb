case ENV['RAILS_ENV']
when 'production'
  then
  $global_url = "http://micongreso.mx"
  $paperclip_bucket = "diputado"
  $like = "ILIKE"
when 'staging'
  then
  $global_url = "http://www.diputadovirtualtest.com"
  $paperclip_bucket = "diputado_test"
  $like = "LIKE"
else
  $global_url = "http://diputado.local"
  $paperclip_bucket = "diputado_dev"
  $like = "LIKE"
end