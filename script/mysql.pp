class { '::mysql::server':
  root_password    => '?ia5luylUD1?uvi5_r4e',
  override_options => { 
    'mysqld' => { 
      'bind-address' => '0.0.0.0' 
    }
  }
}

mysql::db { 'defaults':
  user     => 'canto',
  password => 'C*iEpr3ePrO@CRI7xoUX',
  host     => '%',
  grant    => ['ALL'],
}