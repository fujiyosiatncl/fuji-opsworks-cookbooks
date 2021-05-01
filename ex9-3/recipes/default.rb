app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"

raise app.inspect

database = app[:database]
host = database[:host]
user = database[:username]
pass = database[:password]
dbname = database[:database]

sql = 
  "insert into food values (101, '#{host}', 'NA', 99); " +
  "insert into food values (102, '#{dbname}', 'NA', 99); " +
  "insert into food values (103, '#{user}', 'NA', 99); " +
  "insert into food values (104, '#{pass}', 'NA', 99); "

commands = <<-"EOS"
echo "Fuji start"
mysql -h #{host} -u #{user} -p#{pass} -D #{dbname} -e "#{sql}"
echo "Fuji end"
EOS

bash "DB connectivity test" do
  code commands
end
