# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-server' do
  describe 'ubuntu' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }
    let(:file) { chef_run.template('/etc/mysql/conf.d/openstack.cnf') }

    it 'overrides mariadb default attributes' do
      expect(chef_run.node['mariadb']['mysqld']['bind_address']).to eq '127.0.0.1'
      expect(chef_run.node['mariadb']['mysqld']['default_storage_engine']).to eq 'InnoDB'
      expect(chef_run.node['mariadb']['mysqld']['max_connections']).to eq '151'
      expect(chef_run.node['mariadb']['forbid_remote_root']).to be true
    end

    it 'includes mariadb recipes' do
      expect(chef_run).to include_recipe('openstack-ops-database::mariadb-client')
      expect(chef_run).to include_recipe('mariadb::server')
    end

    it 'creates template /etc/mysql/conf.d/openstack.cnf' do
      node.set['mariadb']['install']['version'] = '5.5'
      expect(chef_run).to create_template(file.name).with(
        user: 'mysql',
        group: 'mysql',
        source: 'openstack.cnf.erb'
      )
      expect(file).to notify('service[mysql]')
      [/^default-storage-engine = InnoDB$/,
       /^innodb_autoinc_lock_mode = 1$/,
       /^innodb_file_per_table = OFF$/,
       /^innodb_thread_concurrency = 0$/,
       /^innodb_commit_concurrency = 0$/,
       /^innodb_read_io_threads = 4$/,
       /^innodb_flush_log_at_trx_commit = 1$/,
       /^innodb_buffer_pool_size = 134217728$/,
       /^innodb_log_file_size = 5242880$/,
       /^innodb_log_buffer_size = 8388608$/,
       /^character-set-server = latin1$/,
       /^query_cache_size = 0$/,
       /^max_connections = 151$/].each do |line|
        expect(chef_run).to render_config_file(file.name)\
          .with_section_content('mysqld', line)
      end
    end

    it 'creates mariadb with root password' do
      # Password is fixed as 'abc123' by spec_helper
      expect(chef_run.node['mariadb']['allow_root_pass_change']).to be true
      expect(chef_run.node['mariadb']['server_root_password']).to eq 'abc123'
    end

    it 'override prefer os package' do
      expect(chef_run.node['mariadb']['install']['prefer_os_package']).to be true
    end

    it 'allow root remote access' do
      node.set['openstack']['endpoints']['db']['host'] = '192.168.1.1'
      expect(chef_run.node['mariadb']['forbid_remote_root']).to be false
    end

    it 'drop anonymous and empty users' do
      expect(chef_run).to query_mysql_database('drop empty and default users')\
        .with(database_name: 'mysql',
              sql: "DELETE FROM mysql.user WHERE User = '' OR Password = ''")
      expect(chef_run).to drop_mysql_database('test')
      expect(chef_run).to query_mysql_database('flush priviledges after cleanup')\
        .with(database_name: 'mysql',
              sql: 'FLUSH PRIVILEGES')
    end
  end
end
