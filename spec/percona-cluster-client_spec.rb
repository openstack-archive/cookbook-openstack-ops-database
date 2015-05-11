# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::percona-cluster-client' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) do
      runner.node.set['openstack']['db']['service_type'] = 'percona-cluster'
      runner.node
    end
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes percona client recipes' do
      expect(chef_run).to include_recipe('percona::client')
    end

    it 'install mysql2 gem package' do
      expect(chef_run).to install_mysql2_chef_gem('default')
        .with(provider: Chef::Provider::Mysql2ChefGem::Percona)
    end

    it 'installs percona python client packages' do
      expect(chef_run).to install_package('python-mysqldb')
    end
  end
end
