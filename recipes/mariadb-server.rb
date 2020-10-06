#
# Cookbook:: openstack-ops-database
# Recipe:: mariadb-server
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

class ::Chef::Recipe
  include ::Openstack
end

bind_db = node['openstack']['bind_service']['db']

listen_address =
  if bind_db['interface']
    address_for bind_db['interface']
  else
    bind_db['host']
  end

super_password = get_password 'db', node['openstack']['db']['root_user_key']

include_recipe 'openstack-ops-database::mariadb-client'

mariadb_server_install 'default' do
  version node['openstack']['mariadb']['version']
  password super_password
  setup_repo node['openstack']['mariadb']['setup_repo']
  action [:install, :create]
end

# Using this to generate a service resource to control
service 'mysql' do
  supports restart: true, status: true, reload: true
  action :nothing
end

mariadb_server_configuration 'default' do
  innodb_buffer_pool_size node['openstack']['mysql']['innodb_buffer_pool_size']
  innodb_file_per_table node['openstack']['mysql']['innodb_file_per_table']
  innodb_log_buffer_size node['openstack']['mysql']['innodb_log_buffer_size']
  innodb_log_file_size node['openstack']['mysql']['innodb_log_file_size']
  innodb_options(
    innodb_autoinc_lock_mode: node['openstack']['mysql']['innodb_autoinc_lock_mode'],
    innodb_thread_concurrency: node['openstack']['mysql']['innodb_thread_concurrency'],
    innodb_commit_concurrency: node['openstack']['mysql']['innodb_commit_concurrency'],
    innodb_read_io_threads: node['openstack']['mysql']['innodb_read_io_threads'],
    innodb_flush_log_at_trx_commit: node['openstack']['mysql']['innodb_flush_log_at_trx_commit']
  )
  mysqld_bind_address listen_address
  mysqld_connect_timeout node['openstack']['mysql']['connect_timeout']
  mysqld_wait_timeout node['openstack']['mysql']['wait_timeout']
  mysqld_tmpdir node['openstack']['mysql']['tmpdir']
  mysqld_default_storage_engine node['openstack']['mysql']['default-storage-engine']
  mysqld_max_connections node['openstack']['mysql']['max_connections']
  mysqld_query_cache_size node['openstack']['mysql']['query_cache_size']
  mysqld_skip_name_resolve node['openstack']['mysql']['skip-name-resolve']
  mysqld_options(
    'character-set-server' => node['openstack']['mysql']['character-set-server']
  )
  version node['openstack']['mariadb']['version']
  notifies :restart, 'service[mysql]', :immediately
end

# Remove anonymous localhost user
mariadb_user 'anonymous' do
  username ''
  host 'localhost'
  ctrl_password super_password
  action :drop
end

# Remove test database
mariadb_database 'test' do
  password super_password
  action :drop
end
