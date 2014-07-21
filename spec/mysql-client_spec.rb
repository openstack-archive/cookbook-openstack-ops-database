# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mysql-client' do
  include_context 'database-stubs'
  describe 'ubuntu' do
    let(:runner) { ChefSpec::Runner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    it 'includes mysql client recipes' do
      expect(chef_run).to include_recipe 'mysql::client'
    end

    it 'includes mysql-chef_gem recipes' do
      expect(chef_run).to include_recipe 'mysql-chef_gem::default'
    end

    it 'installs mysql packages' do
      expect(chef_run).to install_package 'python-mysqldb'
    end
  end
end
