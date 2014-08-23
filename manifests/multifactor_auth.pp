class profile::multifactor_auth (
  $radius_secret,
  $services = {},
  $ensure   = present,
) {

  include pam_radius

  $defaults = {
    ensure   => $ensure,
    type     => 'auth',
    control  => 'required',
    module   => 'pam_radius_auth.so',
    position => 'before first',
  }

  create_resources('pam',$services,$defaults)

  @@freeradius::client { $::fqdn:
    ensure    => $ensure,
    secret    => $radius_secret,
    shortname => $::hostname,
    tag       => 'radius_client',
  }
}
