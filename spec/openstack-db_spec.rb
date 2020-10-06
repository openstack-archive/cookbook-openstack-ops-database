require_relative 'spec_helper'

describe 'openstack-ops-database::openstack-db' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) { runner.converge(described_recipe) }

    it 'creates all openstack service databases and the corresponding users' do
      {
        'compute' => 'nova',
        'dashboard' => 'horizon',
        'database' => 'trove',
        'identity' => 'keystone',
        'image' => 'glance',
        'network' => 'neutron',
        'orchestration' => 'heat',
        'telemetry' => 'ceilometer',
      }.each do |service, _project|
        expect(chef_run).to create_openstack_database(service)
          .with(user: node['openstack']['db'][service]['username'], pass: 'test-pass')
      end
      ## TODO: utilize _project and create test for rescue with specific log message
      ##       when databag does not exist
    end
  end
end
