# encoding: UTF-8
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'openstack-ops-database' }

LOG_LEVEL = :fatal
SUSE_OPTS = {
  platform: 'suse',
  version: '11.3',
  log_level: ::LOG_LEVEL
}
REDHAT_OPTS = {
  platform: 'redhat',
  version: '7.1',
  log_level: ::LOG_LEVEL
}
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '14.04',
  log_level: ::LOG_LEVEL
}

shared_context 'database-stubs' do
  before do
    # for redhat
    stub_command("/usr/bin/mysql -u root -e 'show databases;'")
    # for debian
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'")
    # for postgresql
    stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf')

    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('lo')
      .and_return('127.0.0.1')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', anything)
      .and_return('test-pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('user', 'mysqlroot')
      .and_return('abc123')
  end
end
