class profile::base (
  $packages = undef,
  $sysctlvalues = undef,
  $grubkernelparams = undef,
  $grubtimeout = 10,
  $sshd_config = undef,
  $sshd_subsystems = undef,
  $selinux_mode = 'enforcing',
  $hiera_merge = false,
) {

  $myclass = "${module_name}::base"

  include etckeeper
  include network
  include usermanagement
  include puppet
  include yumcron
  include duplicity

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

  if $packages != undef {
    if !is_hash($packages) {
        fail("${myclass}::packages must be a hash.")
    }

    if $hiera_merge_real == true {
      $packages_real = hiera_hash("${myclass}::packages")
    } else {
      $packages_real = $packages
    }

    create_resources('package',$packages_real)
  }

  if $sysctlvalues != undef {
    if !is_hash($sysctlvalues) {
        fail("${myclass}::sysctlvalues must be a hash.")
    }

    if $hiera_merge_real == true {
      $sysctlvalues_real = hiera_hash("${myclass}::sysctlvalues")
    } else {
      $sysctlvalues_real = $sysctlvalues
    }

    create_resources('sysctl',$sysctlvalues_real)
  }

  if $grubkernelparams != undef {
    if !is_hash($grubkernelparams) {
        fail("${myclass}::grubkernelparams must be a hash.")
    }

    if $hiera_merge_real == true {
      $grubkernelparams_real = hiera_hash("${myclass}::grubkernelparams")
    } else {
      $grubkernelparams_real = $grubkernelparams
    }

    create_resources('kernel_parameter',$grubkernelparams_real)
  }

  if $sshd_config != undef {
    if !is_hash($sshd_config) {
        fail("${myclass}::sshd_config must be a hash.")
    }

    if $hiera_merge_real == true {
      $sshd_config_real = hiera_hash("${myclass}::sshd_config")
    } else {
      $sshd_config_real = $sshd_config
    }

    create_resources('sshd_config',$sshd_config_real)
  }
  if $sshd_subsystems != undef {
    if !is_hash($sshd_subsystems) {
        fail("${myclass}::sshd_subsystems must be a hash.")
    }

    if $hiera_merge_real == true {
      $sshd_subsystems_real = hiera_hash("${myclass}::sshd_subsystems")
    } else {
      $sshd_subsystems_real = $sshd_subsystems
    }

    create_resources('sshd_config_subsystem',$sshd_subsystems)
  }

  # "brute-force" changes for which I have yet
  # to find a more flexible/scalable solution
  file_line { 'root unalias cp':
    ensure => absent,
    line   => 'alias cp="cp -i"',
    path   => '/root/.bashrc'
  }

  file_line { 'root unalias mv':
    ensure => absent,
    line   => 'alias mv="mv -i"',
    path   => '/root/.bashrc'
  }

  file_line { 'root unalias rm':
    ensure => absent,
    line   => 'alias rm="rm -i"',
    path   => '/root/.bashrc'
  }

  validate_re($selinux_mode, '^(enforcing|permissive|disabled)$', "${myclass}::selinux_mode may be either 'enforcing','permissive' or 'disabled' and is set to <${hiera_merge}>.")
  augeas { 'selinux mode':
    context => '/files/etc/selinux/config',
    incl    => '/etc/selinux/config',
    lens    => 'Shellvars.lns',
    changes => "set SELINUX ${selinux_mode}"
  }

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      augeas { 'grub config':
        context => '/files/etc/grub.conf',
        incl    => '/etc/grub.conf',
        lens    => 'Grub.lns',
        changes => [
          'rm hiddenmenu',
          'rm splashimage',
          "set timeout ${grubtimeout}",
        ]
      }
    }
    'Fedora': {
      augeas { 'grub config':
        context => '/files/etc/sysconfig/grub',
        incl    => '/etc/sysconfig/grub',
        lens    => 'Shellvars.lns',
        changes => [
          'rm GRUB_BACKGROUND',
          "set GRUB_TIMEOUT ${grubtimeout}"
        ],
        notify  => Exec['update-grub']
      }

      exec { 'update-grub':
        path        => '/sbin:/usr/sbin:/bin:/usr/bin',
        command     => 'grub2-mkconfig -o /boot/grub2/grub.cfg',
        refreshonly => true
      }
    }
    default: {}
  }
}
