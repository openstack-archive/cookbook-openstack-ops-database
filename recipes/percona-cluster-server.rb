# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: percona-cluster-server
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

## INFO: to use this recipe, set node['percona']['server']['role'] = %w(cluster) in your environment

bind_db = node['openstack']['bind_service']['db']
if bind_db['interface']
  listen_address = address_for bind_db['interface']
  node.normal['percona']['cluster']['wsrep_sst_receive_address'] = listen_address
  node.normal['percona']['server']['bind_address'] = listen_address
  node.normal['percona']['server']['port'] = bind_db['port']
else
  listen_address = bind_db['host']
  node.normal['percona']['server']['bind_address'] = listen_address
  node.normal['percona']['server']['port'] = node['openstack']['endpoints']['db']['port']
end

## CLUSTER SPECIFIC CONFIG
node.normal['percona']['cluster']['wsrep_node_name'] = node['fqdn']
node.normal['percona']['cluster']['wsrep_cluster_name'] = 'openstack'
node.normal['percona']['cluster']['wsrep_provider_options'] = "\"gmcast.listen_addr=tcp://#{listen_address}:4567;\""
# query_cache is not supported with wsrep
node.normal['percona']['server']['query_cache_size'] = 0
# find all nodes in the percona cluster
cluster_nodes = search(:node, 'recipes:"percona\:\:cluster"').sort
# if it's the first node make sure that wsrep_cluster_address is set to nothing to be able to bootstrap.
is_first_node = cluster_nodes.empty? || (cluster_nodes.size == 1 && cluster_nodes.first['fqdn'] == node['fqdn'])
if is_first_node
  node.normal['percona']['cluster']['wsrep_cluster_address'] = 'gcomm://'
else
  # otherwise set the correct cluster address with all cluster nodes
  family = node['openstack']['endpoints']['family']
  cluster_nodes_addresses = []
  cluster_nodes.each do |cluster_node|
    address = address_for bind_db['interface'], family, cluster_node
    cluster_nodes_addresses << address
  end
  cluster_address = cluster_nodes_addresses.join(',')
  node.normal['percona']['cluster']['wsrep_cluster_address'] = "gcomm://#{cluster_address}"
end

include_recipe 'openstack-ops-database::percona-cluster-client'
include_recipe 'percona::cluster'
