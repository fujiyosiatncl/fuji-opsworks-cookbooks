#
# See
#   https://docs.aws.amazon.com/opsworks/latest/userguide/data-bags.html
#

dbins = search('aws_opsworks_rds_db_instance').first
pass = dbins['db_password']
user = dbins['db_user']
host = dbins['address']
str = "#{Time.now} / #{host} / #{user} / #{pass}"
sql = "insert into fuji.tempura values ('#{str}')"
cmd = "mysql -h #{host} -u #{user} -p#{pass} -e \"#{sql}\""

package "mariadb" do
  action :install
end

script "DVA Ex9.3" do
  interpreter "bash"
  user "root"
  code cmd
end
