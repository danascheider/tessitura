class { '::mysql::server':
  root_password    => 'hunter2',
  override_options => { 
    'mysqld' => { 
      'bind-address' => '0.0.0.0' 
    }
  }
}

mysql::db { 'development':
  user     => 'canto',
  password => 'hunter2',
  host     => '%',
  grant    => ['ALL'],
}
mysql::db { 'test':
  user     => 'canto',
  password => 'hunter2',
  host     => '%',
  grant    => ['ALL'],
}
mysql::db { 'production':
  user     => 'canto',
  password => 'hunter2',
  host     => '%',
  grant    => ['ALL'],
}
