include_recipe "percona::server"
include_recipe "database"

gem_package "mysql" do
  action :install
end

mysql_connection_info = {:host => node[:magento][:db][:host], :username => 'root', :password => node['mysql']['server_root_password']}

# create a mysql database
mysql_database '#{node[:magento][:db][database]}' do
  connection mysql_connection_info
  action :create
end

mysql_database_user '#{node[:magento][:db][:username]}' do
  connection mysql_connection_info
  password '#{node[:magento][:db][:password]}'
  action :create
end

    # grant select,update,insert privileges to all tables in foo db from all hosts
mysql_database_user '#{node[:magento][:db][:username]}' do
  connection mysql_connection_info
  password '#{node[:magento][:db][:password]}'
  database_name '#{node[:magento][:db][database]}'
  host '#{node[:magento][:db][:host]'
  privileges [:select,:update,:insert]
  action :grant
end

