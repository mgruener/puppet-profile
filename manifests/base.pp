class profile::base ($basepackages = any2array(hiera_array('basepackages')),
                     $unwantedpackages = any2array(hiera_array('unwantedpackages')),
                     $sysctlvalues = hiera_hash('sysctlvalues',undef),
                     $grubkernelparams = hiera_hash('grubkernelparameter',undef),
                     $sshd_config = hiera_hash('sshd_config',undef),
                     $sshd_subsystems = hiera_hash('sshd_subsystems',undef)) {

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

  if $sysctlvalues != undef {
    create_resources('sysctl',$sysctlvalues)
  }
  if $grubkernelparams != undef {
    create_resources('kernel_parameter',$grubkernelparams)
  }
  if $sshd_config != undef {
    create_resources('sshd_config',$sshd_config)
  }
  if $sshd_subsystems != undef {
    create_resources('sshd_config_subsystem',$sshd_subsystems)
  }
}
