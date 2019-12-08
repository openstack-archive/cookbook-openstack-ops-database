# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) do
      runner.node
    end
    cached(:chef_run) do
      runner.node.override['openstack']['db']['service_type'] = 'mariadb'
      runner.converge(described_recipe)
    end

    it 'includes mariadb client recipes' do
      expect(chef_run).to include_recipe('mariadb::client')
    end

    it do
      expect(chef_run).to install_mysql2_chef_gem_mariadb('default').with(gem_version: '0.4.9')
    end

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('python3-mysqldb')
    end
  end
end
