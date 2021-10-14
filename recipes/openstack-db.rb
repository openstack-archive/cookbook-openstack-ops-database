#
# Cookbook:: openstack-ops-database
# Recipe:: openstack-db
#
# Copyright:: 2012-2021, AT&T Services, Inc.
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

node['openstack']['common']['services'].each do |service, project|
  old_services = %w(baremetal block-storage application-catalog
                    object-storage telemetry-metric)
  next if old_services.include?(service)
  begin
    username = node['openstack']['db'][service]['username']
    password = get_password('db', project)
    openstack_database service do
      user username
      pass password
    end
  rescue Net::HTTPClientException, ChefVault::Exceptions::KeysNotFound
    Chef::Log.warn("No databag item containing the database password for #{project} was found, so no database was created")
  end
end
