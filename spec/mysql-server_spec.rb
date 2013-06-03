require_relative 'spec_helper'

describe 'openstack-ops-database::mysql-server' do
  describe 'ubuntu' do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
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
      @chef_run.converge "openstack-ops-database::mysql-server"
    end

    it "mysql-client recipe basic test" do
      expect(@chef_run).to include_recipe "openstack-ops-database::mysql-client"
      expect(@chef_run).to include_recipe "mysql::ruby"
      expect(@chef_run).to include_recipe "mysql::client"
      expect(@chef_run).to include_recipe "mysql::server"
      expect(@chef_run).to install_package "python-mysqldb"
    end

  end
end
