class profile::mysqlserver  {
  class { 'mysql::server':
    config_file             => hiera("${module_name}::mysqlserver::config_file",undef),
    manage_config_file      => hiera("${module_name}::mysqlserver::manage_config_file",undef),
    old_root_password       => hiera("${module_name}::mysqlserver::old_root_password",undef),
    override_options        => hiera_hash("${module_name}::mysqlserver::override_options",undef),
    package_ensure          => hiera("${module_name}::mysqlserver::server_package_ensure",undef),
    package_name            => hiera("${module_name}::mysqlserver::server_package_name",undef),
    purge_conf_dir          => hiera("${module_name}::mysqlserver::purge_conf_dir",undef),
    remove_default_accounts => hiera("${module_name}::mysqlserver",undef),
    restart                 => hiera("${module_name}::mysqlserver::restart",undef),
    root_group              => hiera("${module_name}::mysqlserver::root_group",undef),
    root_password           => hiera("${module_name}::mysqlserver::root_password",undef),
    service_enabled         => hiera("${module_name}::mysqlserver::server_service_enabled",undef),
    service_manage          => hiera("${module_name}::mysqlserver::server_service_manage",undef),
    service_name            => hiera("${module_name}::mysqlserver::server_service_name",undef),
    service_provider        => hiera("${module_name}::mysqlserver::server_service_provider",undef),
    users                   => hiera_hash("${module_name}::mysqlserver::users",undef),
    grants                  => hiera_hash("${module_name}::mysqlserver::grants",undef),
    databases               => hiera_hash("${module_name}::mysqlserver::databases",undef)
  }
}
