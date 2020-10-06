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

    it do
      expect(chef_run).to install_mariadb_client_install('default').with(version: '10.3')
    end

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('python3-mysqldb')
    end
  end
end
