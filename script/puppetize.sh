#!/bin/bash

puppet module install puppetlabs-mysql
puppet apply /vagrant/script/mysql.pp
