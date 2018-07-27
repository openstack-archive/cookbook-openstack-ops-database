source 'https://supermarket.chef.io'

if Dir.exist?("../cookbook-openstack-common")
  cookbook "openstack-common", path: "../cookbook-openstack-common"
else
  cookbook "openstack-common", git: "https://git.openstack.org/openstack/cookbook-openstack-common", branch: 'stable/queens'
end

metadata
