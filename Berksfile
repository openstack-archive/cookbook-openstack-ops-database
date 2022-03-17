source 'https://supermarket.chef.io'

solver :ruby, :required

%w(common).each do |cookbook|
  if Dir.exist?("../cookbook-openstack-#{cookbook}")
    cookbook "openstack-#{cookbook}", path: "../cookbook-openstack-#{cookbook}"
  else
    cookbook "openstack-#{cookbook}", git: "https://opendev.org/openstack/cookbook-openstack-#{cookbook}",
      branch: 'stable/train'
  end
end

metadata
