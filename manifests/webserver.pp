class profile::webserver {
  include apache

  if $::operatingsystem == 'Fedora' {
    if $::operatingsystemmajrelease > 17 {
      Service { provider => 'systemd' }
      if !defined(Apache::Mod['unixd']) { apache::mod { 'unixd': } }
      if !defined(Apache::Mod['access_compat']) { apache::mod { 'access_compat': } }
      if !defined(Apache::Mod['systemd']) { apache::mod { 'systemd': } }
    }
  }
}
