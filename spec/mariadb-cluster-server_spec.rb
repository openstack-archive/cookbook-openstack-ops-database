require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-cluster-server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) do
      node.override['openstack']['bind_service']['db']['interface'] = 'lo'
      runner.converge(described_recipe)
    end

    it 'includes mariadb recipes' do
      expect(chef_run).to include_recipe('openstack-ops-database::mariadb-server')
    end

    it do
      expect(chef_run).to create_mariadb_galera_configuration('MariaDB Galera Configuration').with(
        version: '10.3',
        cluster_name: 'openstack',
        gcomm_address: 'gcomm://',
        wsrep_provider_options: { 'gcache.size': '512M', 'gmcast.listen_addr': 'tcp://127.0.0.1:4567' },
        wsrep_sst_method: 'rsync'
      )
    end

    it do
      expect(chef_run.mariadb_galera_configuration('MariaDB Galera Configuration')).to notify('service[mysql]').to(:restart).immediately
    end

    it do
      expect(chef_run).to create_if_missing_cookbook_file('/usr/bin/clustercheck').with(
        source: 'clustercheck',
        owner: 'root',
        group: 'root',
        mode: '0755'
      )
    end
  end
end
