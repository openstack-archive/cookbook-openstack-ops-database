# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) do
      runner.node.set['openstack']['db']['service_type'] = 'mariadb'
      runner.node
    end
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes mariadb client recipes' do
      expect(chef_run).to include_recipe('mariadb::client')
    end

    it 'install mysql2 gem package' do
      expect(chef_run).to install_mysql2_chef_gem('default')
        .with(provider: Chef::Provider::Mysql2ChefGem::Mariadb)
    end

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('python-mysqldb')
    end

    it 'override prefer os package' do
      expect(chef_run.node['mariadb']['install']['prefer_os_package']).to be true
    end
  end
end
