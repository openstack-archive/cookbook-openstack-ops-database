# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    it 'uses mysql database server recipe by default' do
      expect(chef_run).to include_recipe('openstack-ops-database::mysql-server')
    end

    it 'uses postgresql database server recipe when configured' do
      node.set['openstack']['db']['service_type'] = 'postgresql'
      # The postgresql cookbook will raise an 'uninitialized constant
      # Chef::Application' error without this attribute when running
      # the tests
      node.set_unless['postgresql']['password']['postgres'] = ''

      expect(chef_run).to include_recipe(
        'openstack-ops-database::postgresql-server')
    end
  end
end
