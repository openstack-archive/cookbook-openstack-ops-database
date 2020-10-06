require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  describe 'redhat' do
    let(:runner) { ChefSpec::SoloRunner.new(REDHAT_OPTS) }
    let(:node) do
      runner.node
    end
    cached(:chef_run) do
      runner.node.override['openstack']['db']['service_type'] = 'mariadb'
      runner.converge(described_recipe)
    end

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('MySQL-python')
    end
  end
end
