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

  Class['mysql::server::service'] -> Class['zarafa::server']
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
    notify => Exec[join-zarafa-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }

  certtool::cert { "${serverhostname}-dagent":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    notify => Exec[join-dagent-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }
  certtool::cert { "${serverhostname}-ical":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    notify => Exec[join-ical-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }
  certtool::cert { "${serverhostname}-gateway":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    notify => Exec[join-gateway-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }
  certtool::cert { "${serverhostname}-search":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    notify => Exec[join-search-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }
  certtool::cert { "${serverhostname}-monitor":
    usage => $usage,
    unit => "test",
    extract_pubkey => true,
    notify => Exec[join-monitor-ssl-keyfile],
    require => [ File[$certdir], File[$keydir] ]
  }

  exec { 'join-zarafa-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}.key >> ${certdir}/${serverhostname}.crt",
    refreshonly => true,
    require => Certtool::Cert[$serverhostname]
  }

  exec { 'join-spooler-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-spooler.key >> ${certdir}/${serverhostname}-spooler.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-spooler"]
  }
  exec { 'join-dagent-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-dagent.key >> ${certdir}/${serverhostname}-dagent.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-dagent"]
  }
  exec { 'join-ical-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-ical.key >> ${certdir}/${serverhostname}-ical.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-ical"]
  }
  exec { 'join-gateway-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-gateway.key >> ${certdir}/${serverhostname}-gateway.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-gateway"]
  }
  exec { 'join-monitor-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-monitor.key >> ${certdir}/${serverhostname}-monitor.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-monitor"]
  }
  exec { 'join-search-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat ${keydir}/${serverhostname}-search.key >> ${certdir}/${serverhostname}-search.crt",
    refreshonly => true,
    require => Certtool::Cert["${serverhostname}-search"]
  }

}
