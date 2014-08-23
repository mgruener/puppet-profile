class profile::multifactor_auth (
  $radius_secret,
  $services = {},
) {

  include pam_radius

  $defaults = {
    type     => 'auth',
    control  => 'required',
    module   => 'pam_radius_auth.so',
    position => 'before first entry',
  }

  create_resources('pam',$services,$defaults)

  @@freeradius::client { $::fqdn:
    secret => $radius_secret,
    tag    => 'radius_client',
  }
}
