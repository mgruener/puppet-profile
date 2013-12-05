class profile::base ($basepackages = any2array(hiera_array('basepackages')),
                     $unwantedpackages = any2array(hiera_array('unwantedpackages')),
                     $sysctlvalues = hiera_hash('sysctlvalues')) {

  package { $basepackages: ensure => present }
  package { $unwantedpackages: ensure => absent }

  include etckeeper
  include network
  include usermanagement

  file_line { "root unalias cp":
    ensure => absent,
    line => "alias cp='cp -i'",
    path => "/root/.bashrc"
  }

  file_line { "root unalias mv":
    ensure => absent,
    line => "alias mv='mv -i'",
    path => "/root/.bashrc"
  }

  file_line { "root unalias rm":
    ensure => absent,
    line => "alias rm='rm -i'",
    path => "/root/.bashrc"
  }

  create_resources('sysctl',$sysctlvalues)
}
