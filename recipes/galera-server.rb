# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: galera-server
#
# Copyright 2014, Autodesk, Inc.
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

if node['openstack']['db']['root_user_use_databag']
  super_password = get_password 'user', node['openstack']['db']['root_user_key']
else
  super_password = node['mysql']['server_root_password']
end

Chef::Log.info "[Autumn] super_password is  #{super_password}"

node.override['mysql']['root_password'] = super_password
  
include_recipe 'galera::server'

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
