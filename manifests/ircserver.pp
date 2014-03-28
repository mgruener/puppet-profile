class profile::ircserver (
  $channels = undef,
  $opers = undef,
  $servers = undef,
  $certdata = {},
  $hiera_merge = false,
) {

  $myclass = "${module_name}::ircserver"

  include ngircd

  $ssl = str2bool(getvar('ngircd::ssl'))

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

  if $certdata != undef {
    if !is_hash($certdata) {
        fail("${myclass}::certdata must be a hash.")
    }

    if $hiera_merge_real == true {
      $certdata_real = hiera_hash("${myclass}::certdata",{})
    } else {
      $certdata_real = $certdata
    }
  }

  if $ssl {
    include certtool

    $certfile = getvar('ngircd::certfile')
    $keyfile = getvar('ngircd::keyfile')
    $certname = inline_template('<%= File.basename(@certfile,".*") %>')

    certtool::cert { $certname:
      certpath        => dirname($certfile),
      keypath         => dirname($keyfile),
      common_name     => $::fqdn,
      self_signed     => true,
      organization    => $certdata_real[organization],
      unit            => $certdata_real[unit],
      locality        => $certdata_real[locality],
      state           => $certdata_real[state],
      country         => $certdata_real[country],
      expiration_days => $certdata_real[expidation_days],
      dns_names       => $certdata_real[dns_names],
    }
  }
}
