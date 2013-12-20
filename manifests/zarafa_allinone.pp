class profile::zarafa_allinone (
  $serverhostname = hiera('zarafa::server::hostname',$::fqdn),
  $mysqluser      = hiera('zarafa::server::mysqluser','zarafa'),
  $mysqlpassword  = hiera('zarafa::server::mysqlpassword'),
  $mysqldb        = hiera('zarafa::server::mysqlmysqldb','zarafa'),
  $mysqlhost      = hiera('zarafa::server::mysqlhost','localhost'),
  $certdata       = hiera_hash("${module_name}::zarafa_allinone::certdata"),
) {
  include profile::mysqlserver
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

  mysql::db { $mysqldb:
    user     => $mysqluser,
    password => $mysqlpassword,
    host     => $mysqlhost
  }

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
