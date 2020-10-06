require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) { runner.converge(described_recipe) }

    it 'includes mariadb recipes' do
      expect(chef_run).to include_recipe('openstack-ops-database::mariadb-client')
    end

    it do
      expect(chef_run).to install_mariadb_server_install('default').with(
        version: '10.3',
        password: 'abc123'
      )
    end

    it do
      expect(chef_run).to create_mariadb_server_install('default')
    end

    it do
      expect(chef_run).to modify_mariadb_server_configuration('default').with(
        innodb_buffer_pool_size: '134217728',
        innodb_file_per_table: 0,
        innodb_log_buffer_size: '8388608',
        innodb_log_file_size: '5242880',
        innodb_options: {
          innodb_autoinc_lock_mode: 1,
          innodb_thread_concurrency: 0,
          innodb_commit_concurrency: 0,
          innodb_read_io_threads: 4,
          innodb_flush_log_at_trx_commit: 1,
        },
        mysqld_bind_address: '127.0.0.1',
        mysqld_connect_timeout: 30,
        mysqld_wait_timeout: 600,
        mysqld_tmpdir: '/var/tmp',
        mysqld_default_storage_engine: 'InnoDB',
        mysqld_max_connections: 307,
        mysqld_query_cache_size: '0',
        mysqld_skip_name_resolve: false,
        mysqld_options: {
          'character-set-server' => 'latin1',
        },
        version: '10.3'
      )
    end

    it do
      expect(chef_run.mariadb_server_configuration('default')).to notify('service[mysql]').to(:restart).immediately
    end

    it do
      expect(chef_run).to drop_mariadb_user('anonymous').with(
        username: '',
        host: 'localhost',
        ctrl_password: 'abc123'
      )
    end

    it do
      expect(chef_run).to drop_mariadb_database('test').with(password: 'abc123')
    end

    context 'set db host to 192.168.1.1' do
      cached(:chef_run) do
        node.override['openstack']['bind_service']['db']['host'] = '192.168.1.1'
        runner.converge(described_recipe)
      end
      it do
        expect(chef_run).to modify_mariadb_server_configuration('default').with(
          mysqld_bind_address: '192.168.1.1'
        )
      end
    end
  end
end
