# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: mysql-server
#
# Copyright 2013, Opscode, Inc.
# Copyright 2012-2013, Rackspace US, Inc.
# Copyright 2013, AT&T Services, Inc.
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

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
  include ::Opscode::Mysql::Helpers
end

db_endpoint = endpoint 'db'

if node['openstack']['db']['root_user_use_databag']
  super_password = get_password 'user', node['openstack']['db']['root_user_key']
else
  super_password = node['mysql']['server_root_password']
end

node.override['mysql']['tunable']['default-storage-engine'] = 'InnoDB'
node.override['mysql']['bind_address'] = db_endpoint.host
node.override['mysql']['tunable']['innodb_thread_concurrency'] = '0'
node.override['mysql']['tunable']['innodb_commit_concurrency'] = '0'
node.override['mysql']['tunable']['innodb_read_io_threads'] = '4'
node.override['mysql']['tunable']['innodb_flush_log_at_trx_commit'] = '2'
node.override['mysql']['tunable']['skip-name-resolve'] = true
node.override['mysql']['tunable']['character-set-server'] = 'utf8'

include_recipe 'openstack-ops-database::mysql-client'

mysql_service node['mysql']['service_name'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  server_root_password super_password
  server_debian_password node['mysql']['server_debian_password']
  server_repl_password node['mysql']['server_repl_password']
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  remove_test_database node['mysql']['remove_test_database']
  root_network_acl node['mysql']['root_network_acl']
  action :create
end

# Set the version attribute based on what was actually
# installed.
server_resource = mysql_service node['mysql']['service_name']
server_version = server_resource.parsed_version
node.set['mysql']['version'] = server_version

template '/etc/mysql/conf.d/openstack.cnf' do
  owner 'mysql'
  group 'mysql'
  source 'openstack.cnf.erb'
  notifies :restart, 'mysql_service[default]'
end

mysql_connection_info = {
  host: 'localhost',
  username: 'root',
  password: super_password
}

mysql_database 'FLUSH PRIVILEGES' do
  connection mysql_connection_info
  sql 'FLUSH PRIVILEGES'
  action :query
end

# Unfortunately, this is needed to get around a MySQL bug
# that repeatedly shows its face when running this in Vagabond
# containers:
#
# http://bugs.mysql.com/bug.php?id=69644
mysql_database 'drop empty localhost user' do
  sql "DELETE FROM mysql.user WHERE User = '' OR Password = ''"
  connection mysql_connection_info
  action :query
end

mysql_database 'test' do
  connection mysql_connection_info
  action :drop
end

mysql_database 'FLUSH PRIVILEGES' do
  connection mysql_connection_info
  sql 'FLUSH PRIVILEGES'
  action :query
end
