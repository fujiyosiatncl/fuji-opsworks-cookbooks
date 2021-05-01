#
# [
#   data_bag_item[
#     "aws_opsworks_app",
#     "nodejs_sample_app",
#     {
#       "app_id"=>"ced43a83-cea9-4274-90d0-2719b161776e",
#       "app_source"=>{
#         "password"=>nil,
#         "revision"=>nil,
#         "ssh_key"=>nil,
#         "type"=>"git",
#         "url"=>"https://github.com/awslabs/opsworks-windows-demo-nodejs.git",
#         "user"=>nil
#       },
#       "attributes"=>{
#         "auto_bundle_on_deploy"=>true,
#         "aws_flow_ruby_settings"=>{},
#         "document_root"=>nil,
#         "rails_env"=>nil
#       },
#       "data_sources"=>[
#         {
#           "arn"=>"arn:aws:rds:ap-northeast-1:142901573738:db:fuji-rdsmaria1",
#           "type"=>"RdsDbInstance",
#           "database_name"=>"food"
#         }
#       ],
#       "domains"=>[
#         "nodejs_sample_app"
#       ],
#       "enable_ssl"=>false,
#       "environment"=>{
#         "APP_ADMIN_EMAIL"=>"admin@example.com"
#       },
#       "name"=>"Node.js Sample App",
#       "shortname"=>"nodejs_sample_app",
#       "ssl_configuration"=>{
#         "certificate"=>nil,
#         "private_key"=>nil,
#         "chain"=>nil
#       },
#       "type"=>"other",
#       "deploy"=>true,
#       "id"=>"nodejs_sample_app"
#     }
#   ]
# ]
#
#
# aws_opsworks_rds_db_instance
#

result = search('aws_opsworks_rds_db_instance')
raise result.inspect

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
