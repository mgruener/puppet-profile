class profile::pxeboot (
  $bootserver = $::fqdn,
) {

  include tftp
  include syslinux

  syslinux::images { 'fedora-20-x86_64':
    os      => 'fedora',
    ver     => '20',
    arch    => 'x86_64',
    baseurl => 'http://mirror.hetzner.de/fedora/releases/20/Fedora/x86_64/os/images/pxeboot'
  }

  $syslinux_images = getvar('syslinux::image_root')
  
  tftp::file { 'vmlinuz':
    source => "file:///${syslinux_images}/fedora/20/x86_64/vmlinuz"
  }

  tftp::file { 'initrd.img':
    source => "file:///${syslinux_images}/fedora/20/x86_64/initrd.img"
  }

  tftp::file { 'pxelinux.0':
    source => 'file:///usr/share/syslinux/pxelinux.0',
  }

  tftp::file { 'menu.c32':
    source => 'file:///usr/share/syslinux/menu.c32',
  }

  tftp::file { 'pxelinux.cfg':
    ensure => directory,
  }

  tftp::file { 'pxelinux.cfg/default':
    ensure => file,
    content => template("${module_name}/pxelinux.cfg/default")
  }

}
