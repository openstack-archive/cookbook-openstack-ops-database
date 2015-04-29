# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mysql-server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes mysql recipes' do
      expect(chef_run).to include_recipe 'openstack-ops-database::mysql-client'
    end

    it 'creates mysql default service' do
      expect(chef_run).to create_mysql_service('default').with(
        version: '5.5',
        data_dir: nil,
        initial_root_password: 'abc123',
        bind_address: '127.0.0.1',
        port: '3306',
        action: [:create, :start]
      )
    end

    describe 'openstack.cnf' do
      let(:file) { '/etc/mysql/conf.d/openstack.cnf' }

      it 'creates mysql openstack config and notifies server to restart' do
        expect(chef_run).to create_mysql_config('openstack').with(
          source: 'openstack.cnf.erb',
          action: [:create]
        )
        resource = chef_run.find_resource('mysql_config', 'openstack')
        expect(resource).to notify('mysql_service[default]').to(:restart).delayed
      end

      # TODO: Verify contents of openstack.cnf. This cannot be done properly at
      # present because the mysql_config LWRP comes from the mysql cookbook but
      # does not expose a custom matcher for testing the templates contents.
      # See ChefSpec docs on testing LWRPs from other cookbooks.
      # See issue filed against mysql cookbook:
      # https://github.com/chef-cookbooks/mysql/issues/322
    end
  end
end
