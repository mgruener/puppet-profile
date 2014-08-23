class profile::puppetmaster (
  $use_puppetdb = true,
  $datadir      = '/etc/puppet/data',
) {
  include puppet::master

  if $use_puppetdb == true {
    include puppetdb
    include puppetdb::master::config
  }

  file { $datadir:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    recurse => true,
    mode    => 'go-rwx'
  }
}
