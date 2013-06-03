require_relative 'spec_helper'

describe 'openstack-ops-database::mysql-client' do
  describe 'ubuntu' do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
        node.set['lsb'] = {'codename' => 'precise'}
        node.set['openstack']= {'database' => {
            'service' => 'mysql'
          }
        }
      end
      @chef_run.converge "openstack-ops-database::mysql-client"
    end

    it "mysql-client recipe tests" do
      expect(@chef_run).to include_recipe "mysql::ruby"
      expect(@chef_run).to include_recipe "mysql::client"
      expect(@chef_run).to install_package "python-mysqldb"
    end

  end
end
