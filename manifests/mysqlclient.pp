class profile::mysqlclient {
  include mysql::params
  class { 'mysql::client':
    bindings_enable => hiera("${module_name}::mysqlclient::bindings_enable",$mysql::params::bindings_enable),
    package_ensure  => hiera("${module_name}::mysqlclient::package_ensure",present),
    package_name    => hiera("${module_name}::mysqlclient::package_name",$mysql::params::client_package_name)
  }
}
