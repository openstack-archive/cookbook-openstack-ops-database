require_relative 'spec_helper'

describe 'openstack-ops-database::server' do
  describe 'ubuntu' do

    it "select 'mysql-server' recipe" do
      chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
        node.set['lsb'] = {'codename' => 'precise'}
        node.set['mysql'] = {
          'server_debian_password' => 'foo',
          'server_root_password' => 'bar',
          'server_repl_password' => 'baz'
        }
        node.set['openstack']= {'database' => {
            'service' => 'mysql'
          }
        }
      end
      chef_run.converge 'openstack-ops-database::server'
      expect(chef_run).to include_recipe "openstack-ops-database::mysql-server"
    end

  end
end
