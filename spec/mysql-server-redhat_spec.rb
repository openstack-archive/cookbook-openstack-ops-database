# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ops-database::mysql-server' do
  before { ops_database_stubs }
  describe 'redhat' do
    before do
      @chef_run = ::ChefSpec::Runner.new(::REDHAT_OPTS) do |n|
        n.set['mysql'] = {
          'server_debian_password' => 'server-debian-password',
          'server_root_password' => 'server-root-password',
          'server_repl_password' => 'server-repl-password'
        }
      end
      @chef_run.converge described_recipe
    end

    it 'modifies my.cnf template to notify mysql restart' do
      file = @chef_run.template 'final-my.cnf'
      expect(file).to notify('service[mysql]').to(:restart)
    end
  end
end
