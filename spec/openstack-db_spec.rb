# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::openstack-db' do
  include_context 'database-stubs'

  before do
    @chef_run = ::ChefSpec::Runner.new ::UBUNTU_OPTS
  end

  it 'creates databases and users' do
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with('compute', 'nova', 'test-pass')
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'dashboard', 'dash', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'identity', 'keystone', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'image', 'glance', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'telemetry', 'ceilometer', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'network', 'neutron', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'block-storage', 'cinder', 'test-pass'
    expect_any_instance_of(Chef::Recipe).to receive(:db_create_with_user)
      .with 'orchestration', 'heat', 'test-pass'

    @chef_run.converge(described_recipe)
  end
end
