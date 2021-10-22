require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :warn
end

REDHAT_7 = {
  platform: 'redhat',
  version: '7',
}.freeze

REDHAT_8 = {
  platform: 'redhat',
  version: '8',
}.freeze

ALL_RHEL = [
  REDHAT_7,
  REDHAT_8,
].freeze

UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '18.04',
}.freeze

shared_context 'database-stubs' do
  before do
    # for redhat
    stub_command("/usr/bin/mysql -u root -e 'show databases;'")
    # for debian
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'")
    stub_command("mysqladmin --user=root --password='' version")

    stub_search('node', 'recipes:"openstack-ops-database\:\:mariadb-cluster-server"').and_return([])

    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('lo')
      .and_return('127.0.0.1')
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('all')
      .and_return('0.0.0.0')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', anything)
      .and_return('test-pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', 'mysqlroot')
      .and_return('abc123')
  end
end
