# encoding: UTF-8#
#
# Cookbook Name:: openstack-ops-database
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# MySql attributes that we use the mysql cookbook defaults:

# Data directory
default['openstack']['mysql']['data_dir'] = nil

# MySql attributes that we select defaults for:

# Version, support 5.5 and above
default['openstack']['mysql']['version'] = '5.5'
# Service name
default['openstack']['mysql']['service_name'] = 'default'
# Storage engine, base OpenStack requires the InnoDB flavor
default['openstack']['mysql']['default-storage-engine'] = 'InnoDB'
# InnoDB thread concurrency
default['openstack']['mysql']['innodb_thread_concurrency'] = '0'
# InnoDB commit concurrency
default['openstack']['mysql']['innodb_commit_concurrency'] = '0'
# InnoDB number of read io threads
default['openstack']['mysql']['innodb_read_io_threads'] = '4'
# InnoDB number of commit transactions to flush log
default['openstack']['mysql']['innodb_flush_log_at_trx_commit'] = '2'
# Skip name resolution
default['openstack']['mysql']['skip-name-resolve'] = true
# Character set
default['openstack']['mysql']['character-set-server'] = 'utf8'
# Maximum number of connections
default['openstack']['mysql']['max_connections'] = '1024'
