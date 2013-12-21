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

  Certtool::Cert {
    organization    => $certdata[organization],
    unit            => $certdata[unit],
    locality        => $certdata[locality],
    state           => $certdata[state],
    country         => $certdata[country],
    caname          => $certdata[caname],
    expiration_days => $certdata[expidation_days]
  }
  
  certtool::cert { $certdata[caname]:
    is_ca => true
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
    notify => Exec[join-zarafa-ssl-keyfile]
  }

  certtool::cert { "${serverhostname}-spooler":
    usage => $usage
    unit => "test",
    notify => Exec[join-spooler-ssl-keyfile]
  }

  exec { 'join-zarafa-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat /etc/pki/tls/private/${serverhostname}.key >> /etc/pki/tls/certs/${serverhostname}.crt",
    refreshonly => true
  }

  exec { 'join-spooler-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat /etc/pki/tls/private/${serverhostname}-spooler.key >> /etc/pki/tls/certs/${serverhostname}-spooler.crt",
    refreshonly => true
  }
}
