OpenStack Chef Cookbook - ops-database
======================================

.. image:: https://governance.openstack.org/badges/cookbook-openstack-ops-database.svg
    :target: https://governance.openstack.org/reference/tags/index.html

Description
===========

This cookbook provides a reference example of database configuration for
the OpenStack deployment provided by Chef for OpenStack. It currently
supports MariaDB.

Requirements
============

- Chef 16 or higher
- Chef Workstation 21.10.640 for testing (also includes Berkshelf for cookbook
  dependency resolution)

Platforms
=========

- ubuntu
- redhat
- centos

Cookbooks
=========

The following cookbooks are dependencies:

- 'mariadb', '~> 5.0'
- 'openstack-common', '~> 20.0.0'

Usage
=====

The usage of this cookbook is optional, you may choose to set up your own
databases without using this cookbook. If you choose to do so, you will need to
do the following:

- create the schema specified by the ``openstack-db`` recipe.
- create and upload encrypted data bags into your chef environment, as
  specified by ``#get_password`` in the ``openstack-db`` recipe.

Resources/Providers
===================

None

Templates
=========

None

Recipes
=======

client
------

- Installs client packages for the database used by the deployment.

server
------

- Installs and configures server packages for the database used by the
  deployment.

mariadb-client
--------------

- Installs MariaDB client packages.

mariadb-server
--------------

- Installs and configures MariaDB server packages.

mariadb-cluster-client
----------------------

- Installs MariaDB Cluster client packages.

mariadb-cluster-server
----------------------

- Installs and configures MariaDB Cluster server packages.

openstack-db
------------

- Creates necessary tables, users, and grants for OpenStack.

Attributes
==========

The following attributes are defined in ``attributes/database.rb`` of the
common cookbook, but are documented here due to their relevance:

- ``openstack['endpoints']['db']['host']`` - The IP address to bind the
  database service to
- ``openstack['endpoints']['db']['port']`` - The port to bind the database
  service to
- ``openstack['endpoints']['db']['bind_interface']`` - The interface name to
  bind the database service to
- ``openstack['db']['root_user_key']`` - The key used to retrieve the root user
  password; the key is both the name of the data-bag item and name of
  the key containing the password value within the data-bag item. This
  is defined in Common.

If the value of the ``bind_interface`` attribute is non-nil, then the
database service will be bound to the first IP address on that
interface. If the value of the ``bind_interface`` attribute is nil, then
the database service will be bound to the IP address specified in the
host attribute.

See the attributes ``mysql.rb`` file for the mysql specific attributes
that are available.

For more information see:
http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html

Testing
=======

Please refer to the `TESTING.md`_ for instructions for testing the cookbook.

.. _TESTING.md: cookbook-openstack-ops-database/src/branch/master/TESTING.md

Berkshelf
=========

Berks will resolve version requirements and dependencies on first run
and store these in ``Berksfile.lock.`` If new cookbooks become available
you can run ``berks update`` to update the references in
``Berksfile.lock``.  ``Berksfile.lock`` will be included in stable
branches to provide a known good set of dependencies. ``Berksfile.lock``
will not be included in development branches to encourage development
against the latest cookbooks.

License and Author
==================

+-----------------+---------------------------------------------------+
| **Author**      | Justin Shepherd (justin.shepherd@rackspace.com)   |
+-----------------+---------------------------------------------------+
| **Author**      | Jason Cannavale (jason.cannavale@rackspace.com)   |
+-----------------+---------------------------------------------------+
| **Author**      | Ron Pedde (ron.pedde@rackspace.com)               |
+-----------------+---------------------------------------------------+
| **Author**      | Joseph Breu (joseph.breu@rackspace.com)           |
+-----------------+---------------------------------------------------+
| **Author**      | William Kelly (william.kelly@rackspace.com)       |
+-----------------+---------------------------------------------------+
| **Author**      | Darren Birkett (darren.birkett@rackspace.co.uk)   |
+-----------------+---------------------------------------------------+
| **Author**      | Evan Callicoat (evan.callicoat@rackspace.com)     |
+-----------------+---------------------------------------------------+
| **Author**      | Matt Thompson (matt.thompson@rackspace.co.uk)     |
+-----------------+---------------------------------------------------+
| **Author**      | Matt Ray (matt@opscode.com)                       |
+-----------------+---------------------------------------------------+
| **Author**      | Sean Gallagher ()                                 |
+-----------------+---------------------------------------------------+
| **Author**      | John Dewey (jdewey@att.com)                       |
+-----------------+---------------------------------------------------+
| **Author**      | Ionut Artarisi (iartarisi@suse.cz)                |
+-----------------+---------------------------------------------------+
| **Author**      | Mark Vanderwiel (vanderwl@us.ibm.com)             |
+-----------------+---------------------------------------------------+
| **Author**      | Jan Klare (j.klare@x-ion.de)                      |
+-----------------+---------------------------------------------------+
| **Author**      | Lance Albertson (lance@osuosl.org)                |
+-----------------+---------------------------------------------------+

+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2012-2013, Rackspace US, Inc.       |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2012-2013, Opscode, Inc.            |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2013, AT&T Services, Inc.           |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2013-2014, SUSE Linux GmbH          |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2014-2015, IBM, Corp.               |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2019-2021, Oregon State University  |
+-----------------+---------------------------------------------------+

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

::

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
