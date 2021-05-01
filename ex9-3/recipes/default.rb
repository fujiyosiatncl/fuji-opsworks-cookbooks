#
# search('aws_opsworks_app') ->
#   [
#     {
#       "app_id": "ced43a83-cea9-4274-90d0-2719b161776e",
#       "app_source": {
#         "password": null,
#         "revision": null,
#         "ssh_key": null,
#         "type": "git",
#         "url": "https://github.com/awslabs/opsworks-windows-demo-nodejs.git",
#         "user": null
#       },
#       "attributes": {
#         "auto_bundle_on_deploy": true,
#         "aws_flow_ruby_settings": {
#         },
#         "document_root": null,
#         "rails_env": null
#       },
#       "data_sources": [
#         {
#           "arn": "arn:aws:rds:ap-northeast-1:142901573738:db:fuji-rdsmaria1",
#           "type": "RdsDbInstance",
#           "database_name": "food"
#         }
#       ],
#       "domains": [
#         "nodejs_sample_app"
#       ],
#       "enable_ssl": false,
#       "environment": {
#         "APP_ADMIN_EMAIL": "admin@example.com"
#       },
#       "name": "Node.js Sample App",
#       "shortname": "nodejs_sample_app",
#       "ssl_configuration": {
#         "certificate": null,
#         "private_key": null,
#         "chain": null
#       },
#       "type": "other",
#       "deploy": true
#     }
#   ]
#
#
# https://docs.aws.amazon.com/opsworks/latest/userguide/data-bag-json-rds.html
#
# search('aws_opsworks_rds_db_instance') ->
#   [
#     {
#       "rds_db_instance_arn": "arn:aws:rds:ap-northeast-1:142901573738:db:fuji-rdsmaria1",
#       "db_instance_identifier": "fuji-rdsmaria1",
#       "db_user": "admin",
#       "db_password": "8i3Yqgbgxq9RD9dspNf4",
#       "region": "ap-northeast-1",
#       "address": "fuji-rdsmaria1.c7bguirq0zee.ap-northeast-1.rds.amazonaws.com",
#       "port": 3306,
#       "engine": "mariadb",
#       "missing_on_rds": false
#     }
#   ]
#

app = search('aws_opsworks_app').first
dbname = app['data_sources']['database_name']
dbins = search('aws_opsworks_rds_db_instance').first
pass = dbins['db_password']
user = dbins['db_user']
host = dbins['address']

package "mariadb" do
  action :install
end

script "DB connectivity test" do
  interpreter "bash"
  user "root"
  sql = "insert into tempura values ('#{host} / #{user} / #{pass} / #{dbname}')"
  code "echo \"#{sql}\" > /tmp/hoge.txt"
  code "mysql -h #{host} -u #{user} -p#{pass} -D #{dbname} -e \"#{sql}\""
end
