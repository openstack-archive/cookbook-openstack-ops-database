# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: mariadb-cluster-server
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

## INFO: to use this recipe, set node['openstack']['db']['service_type'] = 'mariadb-cluster' in your environment

bind_db = node['openstack']['bind_service']['db']
if bind_db['interface']
  listen_address = address_for bind_db['interface']
  node.normal['mariadb']['galera']['options']['port'] = bind_db['port']
else
  listen_address = bind_db['host']
  node.normal['mariadb']['galera']['options']['port'] = node['openstack']['endpoints']['db']['port']
end
node.normal['mariadb']['galera']['options']['bind-address'] = listen_address

## CLUSTER SPECIFIC CONFIG
node.normal['mariadb']['galera']['cluster_name'] = 'openstack'
node.normal['mariadb']['galera']['wsrep_provider_options']['gmcast.listen_addr'] = "tcp://#{listen_address}:4567"
### find all nodes in the mariadb cluster
cluster_nodes = search(:node, 'recipes:"openstack-ops-database\:\:mariadb-cluster-server"').sort
# if it's the first node make sure that wsrep_cluster_address is set to nothing to be able to bootstrap.
is_first_node = cluster_nodes.empty? || (cluster_nodes.size == 1 && cluster_nodes.first['fqdn'] == node['fqdn'])
if is_first_node
  node.normal['mariadb']['galera']['gcomm_address'] = 'gcomm://'
else
  # otherwise set the correct cluster address with all cluster nodes
  family = node['openstack']['endpoints']['family']
  cluster_nodes_addresses = []
  cluster_nodes.each do |cluster_node|
    address = address_for bind_db['interface'], family, cluster_node
    cluster_nodes_addresses << address
  end
  cluster_address = cluster_nodes_addresses.join(',')
  node.normal['mariadb']['galera']['gcomm_address'] = "gcomm://#{cluster_address}"
end

include_recipe 'openstack-ops-database::mariadb-client'
include_recipe 'mariadb::galera'

# Install clustercheck tool
cookbook_file '/usr/bin/clustercheck' do
  source 'clustercheck'
  owner 'root'
  group 'root'
  mode '0755'
  action :create_if_missing
end
