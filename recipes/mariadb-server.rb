# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
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

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

db_endpoint = endpoint 'db'
super_password = get_password 'user', node['openstack']['db']['root_user_key']

node.override['mariadb']['allow_root_pass_change'] = true
node.override['mariadb']['server_root_password'] = super_password
node.override['mariadb']['mysqld']['bind_address'] = db_endpoint.host
node.override['mariadb']['install']['prefer_os_package'] = true

unless db_endpoint.host == '127.0.0.1' || db_endpoint.host == 'localhost'
  node.override['mariadb']['forbid_remote_root'] = false
end

include_recipe 'openstack-ops-database::mariadb-client'

# reuse mysql configuration for mariadb
node.override['mariadb']['mysqld']['default_storage_engine'] = node['openstack']['mysql']['default-storage-engine']
node.override['mariadb']['mysqld']['max_connections'] = node['openstack']['mysql']['max_connections']
include_recipe 'mariadb::server'

# reuse mysql configuration file for mariadb
template "#{node['mariadb']['configuration']['includedir']}/openstack.cnf" do
  owner 'mysql'
  group 'mysql'
  source 'openstack.cnf.erb'
  notifies :restart, 'service[mysql]'
end

# Current mariadb cookbook does not handle deleting anonymous users and default
# users. We need to delete them here.
mysql_connection_info = {
  host: 'localhost',
  username: 'root',
  password: super_password
}

mysql_database 'drop empty and default users' do
  database_name 'mysql'
  sql "DELETE FROM mysql.user WHERE User = '' OR Password = ''"
  connection mysql_connection_info
  action :query
end

mysql_database 'test' do
  connection mysql_connection_info
  action :drop
end

mysql_database 'flush priviledges after cleanup' do
  database_name 'mysql'
  sql 'FLUSH PRIVILEGES'
  connection mysql_connection_info
  action :query
end
