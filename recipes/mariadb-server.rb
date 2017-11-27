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

class ::Chef::Recipe
  include ::Openstack
end

bind_db = node['openstack']['bind_service']['db']

listen_address = if bind_db['interface']
                   address_for bind_db['interface']
                 else
                   bind_db['host']
                 end

super_password = get_password 'db', node['openstack']['db']['root_user_key']

node.normal['mariadb']['remove_test_database'] = true
node.normal['mariadb']['allow_root_pass_change'] = true
node.normal['mariadb']['server_root_password'] = super_password
node.normal['mariadb']['mysqld']['bind_address'] = listen_address

unless listen_address == '127.0.0.1' || listen_address == 'localhost'
  node.normal['mariadb']['forbid_remote_root'] = false
end

include_recipe 'openstack-ops-database::mariadb-client'

# reuse mysql configuration for mariadb
node.normal['mariadb']['mysqld']['default_storage_engine'] = node['openstack']['mysql']['default-storage-engine']
node.normal['mariadb']['mysqld']['max_connections'] = node['openstack']['mysql']['max_connections']
include_recipe 'mariadb::server'

# reuse mysql configuration file for mariadb
template "#{node['mariadb']['configuration']['includedir']}/openstack.cnf" do
  owner 'mysql'
  group 'mysql'
  source 'openstack.cnf.erb'
  notifies :restart, 'service[mysql]'
end
