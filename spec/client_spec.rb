require_relative "spec_helper"

describe "openstack-ops-database::client" do
  before { ops_database_stubs }
  describe "ubuntu" do

    it "uses proper database client recipe" do
      chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
      chef_run.converge "openstack-ops-database::client"

      expect(chef_run).to include_recipe "openstack-ops-database::mysql-client"
    end
  end
end
