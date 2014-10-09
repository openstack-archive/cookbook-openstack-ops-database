openstack-ops-database Cookbook CHANGELG
===================================
This file is used to list changes made in each version of the openstack-ops-database cookbook.

## 10.0.0
* Upgrading to Juno
* Upgrading berkshelf from 2.0.18 to 3.1.5
* Switching mysql server recipe to use resource and set password
  directly
* Bump mysql cookbook version for above password patch  

* Bump Chef gem to 11.16
  
## 9.2.0
* Update database and mysql dependency

## 9.1.0
* python_packages database client attributes have been migrated to
the -common cookbook
* bump berkshelf to 2.0.18 to allow Supermarket support
* fix fauxhai version for suse

## 9.0.1
* Fix metadata for database

## 9.0.0
* Upgrade to Icehouse

## 8.1.0
* Rename openstack-metering to openstack-telemetry

## 8.0.0
* Havana support

## 7.0.0

* Initial release intended for Grizzly-based OpenStack releases,
  for use with Stackforge upstream repositories.
