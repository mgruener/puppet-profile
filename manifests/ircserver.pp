class profile::ircserver (
  $channels = {},
  $opers = {},
  $servers = {},
  $certdata = {},
  $hiera_merge = false,
) {

  $myclass = "${module_name}::ircserver"

  include ngircd

  $ssl = str2bool($::ngircd::ssl)

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

  if !is_hash($channels) {
      fail("${myclass}::channels must be a hash.")
  }

  if $hiera_merge_real {
    $channels_real = hiera_hash("${myclass}::channels",{})
  } else {
    $channels_real = $channels
  }
  create_resources('ngircd::channel',$channels_real)
 

  if !is_hash($opers) {
      fail("${myclass}::opers must be a hash.")
  }

  if $hiera_merge_real {
    $opers_real = hiera_hash("${myclass}::opers",{})
  } else {
    $opers_real = $opers
  }
  create_resources('ngircd::oper',$opers_real)

  if !is_hash($servers) {
      fail("${myclass}::servers must be a hash.")
  }

  if $hiera_merge_real {
    $servers_real = hiera_hash("${myclass}::servers",{})
  } else {
    $servers_real = $servers
  }
  create_resources('ngircd::server',$servers_real)

  if !is_hash($certdata) {
      fail("${myclass}::certdata must be a hash.")
  }

  if $hiera_merge_real == true {
    $certdata_real = hiera_hash("${myclass}::certdata",{})
  } else {
    $certdata_real = $certdata
  }

  if $ssl {
    include certtool

    $certfile = $::ngircd::certfile
    $keyfile = $::ngircd::keyfile
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
