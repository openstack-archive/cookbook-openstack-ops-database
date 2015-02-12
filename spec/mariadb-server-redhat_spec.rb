# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-server' do
  describe 'redhat' do
    include_context 'database-stubs'
    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }
    let(:file) { chef_run.template('/etc/my.cnf.d/openstack.cnf') }

    it 'creates template /etc/my.cnf.d/openstack.cnf' do
      node.set['mariadb']['install']['version'] = '5.5'
      expect(chef_run).to create_template(file.name).with(
        user: 'mysql',
        group: 'mysql',
        source: 'openstack.cnf.erb'
      )
      expect(file).to notify('service[mysql]')
      [/^default-storage-engine = InnoDB$/,
       /^innodb_thread_concurrency = 0$/,
       /^innodb_commit_concurrency = 0$/,
       /^innodb_flush_log_at_trx_commit = 2$/,
       /^skip-name-resolve$/,
       /^character-set-server = utf8$/].each do |line|
        expect(chef_run).to render_config_file(file.name)\
          .with_section_content('mysqld', line)
      end
    end
  end
end
