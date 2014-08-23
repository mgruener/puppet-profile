class profile::multifactor_auth (
  $services = {}
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
    secret => 'radius',
    tag    => 'radius_client',
  }
}
