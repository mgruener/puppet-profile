class profile::webserver {
  include apache

  if $::operatingsystem == 'Fedora' {
    if $::operatingsystemmajrelease > 17 {
      Service { provider => 'systemd' }
      apache::mod { 'unixd': }
      apache::mod { 'access_compat': }
      apache::mod { 'systemd': }
    }
  }
}
