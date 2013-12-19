class profile::mysqlclient {
  class { 'mysql::client':
    bindings_enable => hiera("${module_name}::mysqlclient::bindings_enable",undef),
    package_ensure  => hiera("${module_name}::mysqlclient::package_ensure",undef),
    package_name    => hiera("${module_name}::mysqlclient::package_name",undef)
  }
}
