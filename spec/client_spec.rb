require_relative 'spec_helper'

describe 'openstack-ops-database::client' do
  describe 'ubuntu' do

    it "select 'mysql-client' recipe" do
      chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
        node.set['lsb'] = {'codename' => 'precise'}
        node.set['openstack']= {'database' => {
            'service' => 'mysql'
          }
        }
      end
      chef_run.converge 'openstack-ops-database::client'
      expect(chef_run).to include_recipe "openstack-ops-database::mysql-client"
    end

  end
end
