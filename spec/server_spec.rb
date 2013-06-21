require_relative "spec_helper"

describe "openstack-ops-database::server" do
  before { ops_database_stubs }
  describe "ubuntu" do

    it "uses proper database server recipe" do
      chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |n|
        n.set["mysql"] = {
          "server_debian_password" => "server-debian-password",
          "server_root_password" => "server-root-password",
          "server_repl_password" => "server-repl-password"
        }
      end
      chef_run.converge "openstack-ops-database::server"

      expect(chef_run).to include_recipe "openstack-ops-database::mysql-server"
    end
  end
end
