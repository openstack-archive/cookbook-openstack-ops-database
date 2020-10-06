#
# Cookbook:: openstack-ops-database
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

# MySQL attributes that we select defaults for:

# MariaDB version
default['openstack']['mariadb']['version'] = '10.3'
# Whether to set up mariadb repo
default['openstack']['mariadb']['setup_repo'] = true
# Storage engine, base OpenStack requires the InnoDB flavor
default['openstack']['mysql']['default-storage-engine'] = 'InnoDB'
# InnoDB lock mode for generating auto-increment values
default['openstack']['mysql']['innodb_autoinc_lock_mode'] = 1
# InnoDB give each table its own file
default['openstack']['mysql']['innodb_file_per_table'] = 0
# InnoDB thread concurrency
default['openstack']['mysql']['innodb_thread_concurrency'] = 0
# InnoDB commit concurrency
default['openstack']['mysql']['innodb_commit_concurrency'] = 0
# InnoDB number of read io threads
default['openstack']['mysql']['innodb_read_io_threads'] = 4
# InnoDB number of commit transactions to flush log
default['openstack']['mysql']['innodb_flush_log_at_trx_commit'] = 1
# InnoDB memory buffer for caching table data and indexes
default['openstack']['mysql']['innodb_buffer_pool_size'] = '134217728'
# InnoDB size of each log file in a log group
default['openstack']['mysql']['innodb_log_file_size'] = '5242880'
# InnoDB size of buffer for logs
default['openstack']['mysql']['innodb_log_buffer_size'] = '8388608'
# Skip name resolution
default['openstack']['mysql']['skip-name-resolve'] = false
# Character set
default['openstack']['mysql']['character-set-server'] = 'latin1'
# Memory allocated for caching query results
default['openstack']['mysql']['query_cache_size'] = '0'
# Maximum number of connections
default['openstack']['mysql']['max_connections'] = 307
# Increased connect timeout to give services time to warm up
default['openstack']['mysql']['connect_timeout'] = 30
# Default wait timeout
default['openstack']['mysql']['wait_timeout'] = 600
# Default temp directory
default['openstack']['mysql']['tmpdir'] = '/var/tmp'
