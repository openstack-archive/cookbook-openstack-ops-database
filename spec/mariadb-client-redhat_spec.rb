# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  describe 'suse' do
    let(:runner) { ChefSpec::SoloRunner.new(REDHAT_OPTS) }
    let(:node) do
      runner.node.set['openstack']['db']['service_type'] = 'mariadb'
      runner.node
    end
    let(:chef_run) { runner.converge(described_recipe) }

    it 'installs mariadb python client packages' do
      expect(chef_run).to install_package('MySQL-python')
    end
  end
end
