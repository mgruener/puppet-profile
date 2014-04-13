class profile::serfnode (
 $version          = undef,
 $bin_dir          = undef,
 $handlers_dir     = undef,
 $arch             = undef,
 $init_script_url  = undef,
 $init_script_path = undef,
 $config_hash      = undef,
 $handler_script   = 'deploy.sh',
 $hiera_merge      = false,
) {

  $myclass = "${module_name}::serfnode"

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

  if $config_hash != undef {
    if !is_hash($config_hash) {
        fail("${myclass}::config_hash must be a hash.")
    }

    if $hiera_merge_real == true {
      $config_hash_real = hiera_hash("${myclass}::config_hash",{})
    } else {
      $config_hash_real = $config_hash
    }
  } else {
    $config_hash_real = {}
  }

  class { 'serf':
    version          => $version,
    bin_dir          => $bin_dir,
    handlers_dir     => $handlers_dir,
    arch             => $arch,
    init_script_url  => $init_script_url,
    init_script_path => $init_script_path,
    config_hash      => $config_hash_real
  }

  $handler_dir_real = pick($handlers_dir,'/etc/serf/handlers')

  file { "${handler_dir_real}/${handler_script}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    source  => "puppet:///modules/${module_name}/${handler_script}",
    require => Class['serf'],
  }
}
