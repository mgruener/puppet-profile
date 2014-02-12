class profile::ircserver (
  $channels = undef,
  $opers = undef,
  $servers = undef,
  $hiera_merge = false,
) {

  $myclass = "${module_name}::ircserver"

  include ngircd

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

  if $channels != undef {
    if !is_hash($channels) {
        fail("${myclass}::channels must be a hash.")
    }

    if $hiera_merge_real == true {
      $channels_real = hiera_hash("${myclass}::channels",undef)
    } else {
      $channels_real = $channels
    }
    create_resources('ngircd::channel',$channels_real)
  }

  if $opers != undef {
    if !is_hash($opers) {
        fail("${myclass}::opers must be a hash.")
    }

    if $hiera_merge_real == true {
      $opers_real = hiera_hash("${myclass}::opers",undef)
    } else {
      $opers_real = $opers
    }
    create_resources('ngircd::oper',$opers_real)
  }

  if $servers != undef {
    if !is_hash($servers) {
        fail("${myclass}::servers must be a hash.")
    }

    if $hiera_merge_real == true {
      $servers_real = hiera_hash("${myclass}::servers",undef)
    } else {
      $servers_real = $servers
    }
    create_resources('ngircd::server',$servers_real)
  }
}
