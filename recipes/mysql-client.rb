# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: mysql-client
#
# Copyright 2013, Opscode, Inc.
# Copyright 2013, AT&T Services, Inc.
# Copyright 2014, SUSE Linux, GmbH
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

mysql_client 'default' do
  version node['openstack']['mysql']['version']
  action :create
end

# install the mysql development headers
case node['platform_family']
when 'debian'
  package 'libmysqlclient-dev'
when 'rhel'
  package 'mariadb-devel'
end

mysql2_chef_gem 'default' do
  gem_version '0.4.5'
  action :install
end

node['openstack']['db']['python_packages']['mysql'].each do |pkg|
  package pkg
end
