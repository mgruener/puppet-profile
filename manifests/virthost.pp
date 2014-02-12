class profile::virthost (
  $guests = undef,
  $hiera_merge = false,
) {
  $myclass = "${module_name}::virthost"

  include virtualization

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

  if $guests != undef {
    if !is_hash($guests) {
        fail("${myclass}::guests must be a hash.")
    }

    if $hiera_merge_real == true {
      $guests_real = hiera_hash("${myclass}::guests",undef)
    } else {
      $guests_real = $guests
    }

    create_resources('guest',$guests_real)
  }
}
