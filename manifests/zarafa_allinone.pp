class profile::zarafa_allinone (
  $serverhostname = hiera('zarafa::server::hostname',$::fqdn),
  $certdata       = hiera_hash("${module_name}::zarafa_allinone::certdata"),
) {
  include profile::zarafa_dbhost
  include certtool
  include zarafa
  include zarafa::client
  include zarafa::server
  include zarafa::dagent
  include zarafa::spooler
  include zarafa::gateway
  include zarafa::ical
  include zarafa::monitor
  include zarafa::search
  include zarafa::webaccess

  Class['profile::zarafa_dbhost'] -> Class['zarafa::server'] 
  Class['zarafa::server'] -> Class['zarafa::dagent']
  Class['zarafa::server'] -> Class['zarafa::spooler']
  Class['zarafa::server'] -> Class['zarafa::gateway']
  Class['zarafa::server'] -> Class['zarafa::ical']
  Class['zarafa::server'] -> Class['zarafa::monitor']
  Class['zarafa::server'] -> Class['zarafa::search']

  $certdir   = "/etc/zarafa/ssl"
  $keydir    = "/etc/pki/tls/private"
  $pubkeydir = "/etc/zarafa/sslkeys"

  Certtool::Cert {
    certpath        => $certdir,
    keypath         => $keydir,
    pubkeypath      => $pubkeydir,
    organization    => $certdata[organization],
    unit            => $certdata[unit],
    locality        => $certdata[locality],
    state           => $certdata[state],
    country         => $certdata[country],
    caname          => $certdata[caname],
    expiration_days => $certdata[expidation_days]
  }
  
  file { [ $certdir, $keydir, $pubkeydir ]:
    ensure => directory,
  }

  certtool::cert { $certdata[caname]:
    is_ca => true,
    require => [ File[$certdir], File[$keydir] ]
  }

  $usage = [ "tls_www_server",
             "encryption_key",
             "signing_key",
             "tls_www_client",
             "cert_signing_key",
             "crl_signing_key",
             "code_signing_key",
             "ocsp_signing_key",
             "time_stamping_key",
             "ipsec_ike_key"
  ] 

  certtool::cert { $serverhostname:
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }

  certtool::cert { "${serverhostname}-dagent":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }
  certtool::cert { "${serverhostname}-ical":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }
  certtool::cert { "${serverhostname}-gateway":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }
  certtool::cert { "${serverhostname}-search":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }
  certtool::cert { "${serverhostname}-monitor":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    combine_keycert => true,
    require => [ File[$certdir], File[$keydir], File[$pubkeydir] ]
  }
}
