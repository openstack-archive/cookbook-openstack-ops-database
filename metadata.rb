name             'openstack-ops-database'
maintainer       'openstack-chef'
maintainer_email 'openstack-dev@lists.openstack.org'
license          'Apache-2.0'
description      'Provides the shared database configuration for OpenStack'
version          '18.0.0'

recipe 'client', 'Installs client packages for the database used by the deployment.'
recipe 'server', 'Installs and configures server packages for the database used by the deployment.'
recipe 'mysql-client', 'Installs MySQL client packages.'
recipe 'mysql-server', 'Installs and configures MySQL server packages.'
recipe 'mariadb-client', 'Installs MariaDB client packages.'
recipe 'mariadb-server', 'Installs and configures MariaDB server packages.'
recipe 'mariadb-cluster-client', 'Installs MariaDB Cluster client packages.'
recipe 'mariadb-cluster-server', 'Installs and configures MariaDB Cluster server packages.'
recipe 'openstack-db', 'Creates necessary tables, users, and grants for OpenStack.'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 18.0.0'

depends 'mariadb', '~> 1.5'
depends 'mysql', '~> 8.2'
depends 'mysql2_chef_gem', '~> 2.0'

issues_url 'https://launchpad.net/openstack-chef' if respond_to?(:issues_url)
source_url 'https://github.com/openstack/cookbook-openstack-ops-database' if respond_to?(:source_url)
chef_version '>= 12.5' if respond_to?(:chef_version)
