class profile::mysqlserver {
  include mysql::params
  class { 'mysql::server':
    config_file             => hiera("${module_name}::mysqlserver::config_file",$mysql::params::config_file),
    manage_config_file      => hiera("${module_name}::mysqlserver::manage_config_file",$mysql::params::manage_config_file),
    old_root_password       => hiera("${module_name}::mysqlserver::old_root_password",$mysql::params::old_root_password),
    override_options        => hiera_hash("${module_name}::mysqlserver::override_options",{}),
    package_ensure          => hiera("${module_name}::mysqlserver::server_package_ensure",$mysql::params::server_package_ensure),
    package_name            => hiera("${module_name}::mysqlserver::server_package_name",$mysql::params::server_package_name),
    purge_conf_dir          => hiera("${module_name}::mysqlserver::purge_conf_dir",$mysql::params::purge_conf_dir),
    remove_default_accounts => hiera("${module_name}::mysqlserver",false),
    restart                 => hiera("${module_name}::mysqlserver::restart",$mysql::params::restart),
    root_group              => hiera("${module_name}::mysqlserver::root_group",$mysql::params::root_group),
    root_password           => hiera("${module_name}::mysqlserver::root_password",$mysql::params::root_password),
    service_enabled         => hiera("${module_name}::mysqlserver::server_service_enabled",$mysql::params::server_service_enabled),
    service_manage          => hiera("${module_name}::mysqlserver::server_service_manage",$mysql::params::server_service_manage),
    service_name            => hiera("${module_name}::mysqlserver::server_service_name",$mysql::params::server_service_name),
    service_provider        => hiera("${module_name}::mysqlserver::server_service_provider",$mysql::params::server_service_provider),
    users                   => hiera_hash("${module_name}::mysqlserver::users",{}),
    grants                  => hiera_hash("${module_name}::mysqlserver::grants",{}),
    databases               => hiera_hash("${module_name}::mysqlserver::databases",{})
  }
}
