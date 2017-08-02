name             'openstack-ops-database'
maintainer       'openstack-chef'
maintainer_email 'openstack-dev@lists.openstack.org'
license          'Apache 2.0'
description      'Provides the shared database configuration for Chef for OpenStack.'
version          '15.0.0'

recipe 'client', 'Installs client packages for the database used by the deployment.'
recipe 'server', 'Installs and configures server packages for the database used by the deployment.'
recipe 'mysql-client', 'Installs MySQL client packages.'
recipe 'mysql-server', 'Installs and configures MySQL server packages.'
recipe 'mariadb-client', 'Installs MariaDB client packages.'
recipe 'mariadb-server', 'Installs and configures MariaDB server packages.'
recipe 'postgresql-client', 'Installs PostgreSQL client packages.'
recipe 'postgresql-server', 'Installs and configures PostgreSQL server packages.'
recipe 'openstack-db', 'Creates necessary tables, users, and grants for OpenStack.'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 15.0.0'

depends 'database', '~> 6.1'
depends 'mariadb', '~> 1.5'
depends 'mysql', '~> 8.2'
depends 'mysql2_chef_gem', '~> 2.0'
depends 'percona', '~> 0.16.1'
depends 'postgresql', '~> 5.1'

issues_url 'https://launchpad.net/openstack-chef' if respond_to?(:issues_url)
source_url 'https://github.com/openstack/cookbook-openstack-ops-database' if respond_to?(:source_url)
chef_version '>= 12.5' if respond_to?(:chef_version)
