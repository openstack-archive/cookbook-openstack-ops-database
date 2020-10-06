require_relative 'spec_helper'

describe 'openstack-ops-database::server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) { runner.converge(described_recipe) }

    it 'uses mariadb server recipe by default' do
      node.override['openstack']['db']['service_type'] = 'mariadb'
      expect(chef_run).to include_recipe('openstack-ops-database::mariadb-server')
    end
  end
end
