name              "openstack-ops-database"
maintainer        "Opscode, Inc."
maintainer_email  "matt@opscode.com"
license           "Apache 2.0"
description       "Provides the shared database configuration for Chef for OpenStack."
version           "7.0.0"

recipe "client", "Installs client CLI package for the database used by the deployment."
recipe "server", "Installs and configures server packages for the database used by the deployment."

%w{ ubuntu redhat fedora centos }.each do |os|
  supports os
end

depends "database", ">= 1.3.12"
depends "mysql", ">= 3.0.0"
