#!/bin/bash

puppet module install puppetlabs-mysql
puppet module install puppet-rbenv
puppet apply /vagrant/script/mysql.pp
