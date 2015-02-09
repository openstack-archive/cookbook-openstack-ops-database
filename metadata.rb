name              'openstack-ops-database'
maintainer       'openstack-chef'
maintainer_email 'opscode-chef-openstack@googlegroups.com'
license           'Apache 2.0'
description       'Provides the shared database configuration for Chef for OpenStack.'
version           '10.0.0'

recipe 'client', 'Installs client packages for the database used by the deployment.'
recipe 'server', 'Installs and configures server packages for the database used by the deployment.'
recipe 'mysql-client', 'Installs MySQL client packages.'
recipe 'mysql-server', 'Installs and configures MySQL server packages.'
recipe 'postgresql-client', 'Installs PostgreSQL client packages.'
recipe 'postgresql-server', 'Installs and configures PostgreSQL server packages.'
recipe 'openstack-db', 'Creates necessary tables, users, and grants for OpenStack.'

%w{ fedora ubuntu redhat centos suse }.each do |os|
  supports os
end

depends 'mysql', '~> 5.4'
depends 'mysql-chef_gem', '~> 0.0.2'
depends 'postgresql', '~> 3.3'
depends 'database', '~> 2.2'
depends 'openstack-common', '>= 10.0.0'
