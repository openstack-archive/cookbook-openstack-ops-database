default['openstack']['database']['server_role'] = 'os-ops-database'

default['openstack']['database']['service'] = 'mysql'

# platform defaults
case platform
when 'redhat', 'centos' # :pragma-foodcritic: ~FC024 - won't fix this
  default['openstack']['database']['platform']['mysql_python_packages'] = [ 'MySQL-python' ]
when 'ubuntu'
  default['openstack']['database']['platform']['mysql_python_packages'] = [ 'python-mysqldb' ]
end
