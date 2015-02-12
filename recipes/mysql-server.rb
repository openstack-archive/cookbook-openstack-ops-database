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
end

db_endpoint = endpoint 'db'

super_password = get_password 'user', node['openstack']['db']['root_user_key']

include_recipe 'openstack-ops-database::mysql-client'

mysql_service node['openstack']['mysql']['service_name'] do
  version node['openstack']['mysql']['version']
  data_dir node['openstack']['mysql']['data_dir'] if node['openstack']['mysql']['data_dir']
  initial_root_password super_password
  bind_address db_endpoint.host
  port db_endpoint.port.to_s
  action [:create, :start]
end

mysql_config 'openstack' do
  source 'openstack.cnf.erb'
  notifies :restart, "mysql_service[#{node['openstack']['mysql']['service_name']}]"
  action :create
end
