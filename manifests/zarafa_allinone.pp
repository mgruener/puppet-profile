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
    locality        => $certdata[localits],
    state           => $certdata[stat],
    country         => $certdata[country],
    caname          => $certdata[caname],
    expiration_days => $certdata[expidation_days]
  }
  
  certtool::cert { $certdata[caname]:
    is_ca => true
  }

  certtool::cert { $serverhostname:
    usage => "tls_www_server",
    notify => Exec[join-zarafa-ssl-keyfile]
  }

  exec { 'join-zarafa-ssl-keyfile':
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "cat /etc/pki/tls/private/${serverhostname}.key >> /etc/pki/tls/certs/${serverhostname}.crt",
    refreshonly => true
  }
}
