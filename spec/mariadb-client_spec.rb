# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) do
      runner.node.override['openstack']['db']['service_type'] = 'mariadb'
      runner.node
    end
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes mariadb client recipes' do
      expect(chef_run).to include_recipe('mariadb::client')
    end

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('python-mysqldb')
    end
  end
end
