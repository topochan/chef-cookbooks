# General settings
default[:magento][:downloader][:url] = "http://www.magentocommerce.com/downloads/assets/1.6.2.0/magento-1.6.2.0.tar.gz"
default[:magento][:downloader][:checksum] = "91ccdebf0403f0c328cb728b4cd19504"
default[:magento][:version] = "stable"
default[:magento][:dir] = "/var/www/magento"
default[:magento][:gen_cfg] = true
default[:magento][:run_type] = "store"
default[:magento][:run_codes] = Array.new
default[:magento][:user] = "magento"
default[:magento][:db][:host] = "localhost"
default[:magento][:db][:database] = "magentodb"
default[:magento][:db][:username] = "magentouser"
default[:magento][:admin][:email] = "webmaster@example.com"
default[:magento][:admin][:user] = "admin"
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:magento][:db][:password] = secure_password
set_unless[:magento][:admin][:password] = secure_password
