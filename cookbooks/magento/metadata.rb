maintainer       "Yevgeniy Viktorov"
maintainer_email "yeevgen@gmail.com"
license          "Apache 2.0"
description      "Magento app stack"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.1"
recipe           "magento", "Prepare app stack for magento deployments"
recipe           "magento::mysql", "Create mysql database for magento"
recipe           "magento::apache2", "Install apache2 webserver for magento"
recipe           "magento::nginx", "Install nginx webserver for magento"

%w{ debian ubuntu }.each do |os|
  supports os
end

%w{ apache2 nginx mysql openssl php php-fpm }.each do |cb|
  depends cb
end

attribute "magento/dir",
  :display_name => "Magento installation directory",
  :description => "Location to place magento files.",
  :default => "/var/www/magento"

attribute "magento/gen_cfg",
  :display_name => "Magento local.xml generator",
  :description => "The weather the chef should generate local.xml file or leave it to someone also.",
  :default => "true"

attribute "magento/run_type",
  :display_name => "MAGE_RUN_TYPE",
  :description => "",
  :default => "store"

attribute "magento/run_codes",
  :display_name => "MAGE_RUN_CODE",
  :description => "Domain based run codes",
  :default => ""

attribute "magento/user",
  :display_name => "Magento server user",
  :description => "The owner of magento installation directory",
  :default => "magento"

attribute "magento/db/database",
  :display_name => "Magento MySQL database",
  :description => "Magento will use this MySQL database to store its data.",
  :default => "magentodb"

attribute "magento/db/user",
  :display_name => "Magento MySQL user",
  :description => "Magento will connect to MySQL using this user.",
  :default => "magentouser"

attribute "magento/db/password",
  :display_name => "Magento MySQL password",
  :description => "Password for the Magento MySQL user.",
  :default => "randomly generated"

attribute "magento/admin/email",
  :display_name => "Magento Admin email",
  :description => "Email address of the Magento Administrator.",
  :default => "webmaster@localhost"

attribute "magento/admin/user",
  :display_name => "Magento Admin user",
  :description => "User to access Magento Administration panel.",
  :default => "admin"

attribute "magento/admin/password",
  :display_name => "Magento Admin password",
  :description => "Password for the Magento Administration.",
  :default => "randomly generated"
