class profile::zarafa_dbhost (
  $serverhostname = hiera('zarafa::server::hostname','localhost'),
  $mysqluser      = hiera('zarafa::server::mysqluser','zarafa'),
  $mysqlpassword  = hiera('zarafa::server::mysqlpassword'),
  $mysqldb        = hiera('zarafa::server::mysqlmysqldb','zarafa'),
) {
  include profile::mysqlserver
  include profile::mysqlclient

  mysql::db { $mysqldb:
    user     => $mysqluser,
    password => $mysqlpassword,
    host     => $serverhostname
  }

}
