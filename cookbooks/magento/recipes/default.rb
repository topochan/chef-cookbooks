if node.has_key?("ec2")
  server_fqdn = node.ec2.public_hostname
else
  server_fqdn = node.fqdn
end

if "webmaster@localhost" == node[:magento][:admin][:email]
  admin_email = "webmaster@#{server_fqdn}"
else
  admin_email = node[:magento][:admin][:email]
end

# Required extensions
%w{php5-cli php5-common php5-curl php5-gd php5-mcrypt php5-mysql php-pear php-apc}.each do |package|
  package "#{package}" do
    action :upgrade
  end
end

bash "Tweak CLI php.ini file" do
  cwd "/etc/php5/cli"
  code <<-EOH
  sed -i 's/memory_limit = .*/memory_limit = 128M/' php.ini
  sed -i 's/;realpath_cache_size = .*/realpath_cache_size = 32K/' php.ini
  sed -i 's/;realpath_cache_ttl = .*/realpath_cache_ttl = 7200/' php.ini
  EOH
end

bash "Tweak apc.ini file" do
  cwd "/etc/php5/conf.d"
  code <<-EOH
  grep -q -e 'apc.stat=0' apc.ini || echo "apc.stat=0" >> apc.ini
  EOH
end

user "#{node[:magento][:user]}" do
  comment "magento guy"
  home "#{node[:magento][:dir]}"
  system true
end

unless File.exists?("#{node[:magento][:dir]}/installed.flag")

  remote_file "#{Chef::Config[:file_cache_path]}/magento-downloader.tar.gz" do
    checksum node[:magento][:downloader][:checksum]
    source node[:magento][:downloader][:url]
    mode "0644"
  end

  directory "#{node[:magento][:dir]}" do
    owner node[:magento][:user]
    group "www-data"
    mode "0755"
    action :create
    recursive true
  end

  execute "untar-magento" do
    cwd node[:magento][:dir]
    user node[:magento][:user]
    group "www-data"
    command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/magento-downloader.tar.gz"
  end

bash "magento-install-site" do
    cwd node[:magento][:dir]
    user node[:magento][:user] 
    code <<-EOH
rm -f app/etc/local.xml
php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "en_UK" \
--timezone "Europe/London" \
--default_currency "GBP" \
--db_host "#{node[:magento][:db][:host]}" \
--db_name "#{node[:magento][:db][:database]}" \
--db_user "#{node[:magento][:db][:username]}" \
--db_pass "#{node[:magento][:db][:password]}" \
--url "http://#{server_fqdn}/" \
--skip_url_validation \
--use_rewrites "yes" \
--use_secure "yes" \
--secure_base_url "" \
--use_secure_admin "yes" \
--admin_firstname "Admin" \
--admin_lastname "Admin" \
--admin_email "#{admin_email}" \
--admin_username "#{node[:magento][:admin][:user]}" \
--admin_password "#{node[:magento][:admin][:password]}"
echo "php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "en_UK" \
--timezone "Europe/London" \
--default_currency "GBP" \
--db_host "#{node[:magento][:db][:host]}" \
--db_name "#{node[:magento][:db][:database]}" \
--db_user "#{node[:magento][:db][:username]}" \
--db_pass "#{node[:magento][:db][:password]}" \
--url "http://#{server_fqdn}/" \
--skip_url_validation \
--use_rewrites "yes" \
--use_secure "yes" \
--secure_base_url "" \
--use_secure_admin "yes" \
--admin_firstname "Admin" \
--admin_lastname "Admin" \
--admin_email "#{admin_email}" \
--admin_username "#{node[:magento][:admin][:user]}" \
--admin_password "#{node[:magento][:admin][:password]}" " > /tmp/bash-out

touch #{node[:magento][:dir]}/installed.flag
EOH
  end
end

 if node[:magento][:gen_cfg]
    directory "#{node[:magento][:dir]}/app/etc" do
      owner node[:magento][:user]
      group "www-data"
      mode "0755"
      action :create
      recursive true
  end

template "#{node[:magento][:dir]}/app/etc/local.xml" do
    source "local.xml.erb"
    mode "0600"
    owner node[:magento][:user]
    group "www-data"
    variables(:database => node[:magento][:db])
  end
end
