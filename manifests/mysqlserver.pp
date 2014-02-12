class profile::mysqlserver (
    $hiera_merge = false,
) {

  $myclass = "${module_name}::mysqlserver"

  case type($hiera_merge) {
    'string': {
      validate_re($hiera_merge, '^(true|false)$', "${myclass}::hiera_merge may be either 'true' or 'false' and is set to <${hiera_merge}>.")
      $hiera_merge_real = str2bool($hiera_merge)
    }
    'boolean': {
      $hiera_merge_real = $hiera_merge
    }
    default: {
      fail("${myclass}::hiera_merge type must be true or false.")
    }
  }

  if $hiera_merge_real == true {
    class { 'mysql::server':
      override_options        => hiera_hash('mysql::server::override_options',{}),
      users                   => hiera_hash('mysql::server::users',{}),
      grants                  => hiera_hash('mysql::server::grants',{}),
      databases               => hiera_hash('mysql::server::databases',{}),
    }
  } else {
    include mysql::server
  }
}
