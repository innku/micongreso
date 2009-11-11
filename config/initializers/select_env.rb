case ENV['RAILS_ENV']
when 'production'
  then
  $global_url = "http://www.diputadovirtual.mx"
  $paperclip_bucket = "diputado"
when 'staging'
  then
  $global_url = "http://www.diputadovirtualtest.com/"
  $paperclip_bucket = "diputado_test"
else
  $global_url = "diputado.local/"
  $paperclip_bucket = "diputado_dev"
end