# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::percona-cluster-server' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) do
      runner.node.set['openstack']['db']['service_type'] = 'percona-cluster'
      runner.node
    end
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes percona client recipes' do
      expect(chef_run).to include_recipe('percona::cluster')
    end
  end
end
