class profile::puppetmaster (
  $use_puppetdb    = true,
  $datadir         = '/etc/puppet/data',
  $environmentpath = '/etc/puppet/environments',
) {
  include puppet::master
  include r10k

  if $use_puppetdb == true {
    include puppetdb
    include puppetdb::master::config
  }

  puppet::config { 'environmentpath':
    value   => $environmentpath,
    section => 'main',
  }

  file { $datadir:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    recurse => true,
    mode    => 'go-rwx'
  }
}
