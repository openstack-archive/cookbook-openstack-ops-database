name             'openstack-ops-database'
maintainer       'openstack-chef'
maintainer_email 'openstack-discuss@lists.openstack.org'
license          'Apache-2.0'
description      'Provides the shared database configuration for OpenStack'
version          '19.1.0'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 19.0.0'

depends 'mariadb', '~> 3.1'

issues_url 'https://launchpad.net/openstack-chef'
source_url 'https://opendev.org/openstack/cookbook-openstack-ops-database'
chef_version '>= 15.0'
