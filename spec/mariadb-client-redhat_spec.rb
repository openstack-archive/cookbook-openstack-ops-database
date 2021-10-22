require_relative 'spec_helper'

describe 'openstack-ops-database::mariadb-client' do
  ALL_RHEL.each do |p|
    context "redhat #{p[:version]}" do
      let(:runner) { ChefSpec::SoloRunner.new(p) }
      let(:node) do
        runner.node
      end
      cached(:chef_run) do
        runner.node.override['openstack']['db']['service_type'] = 'mariadb'
        runner.converge(described_recipe)
      end

      case p
      when REDHAT_7
        it do
          expect(chef_run).to install_package('MySQL-python')
        end
      when REDHAT_8
        it do
          expect(chef_run).to install_package('python3-PyMySQL')
        end
      end
    end
  end
end
