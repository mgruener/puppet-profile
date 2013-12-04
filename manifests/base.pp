class profile::base ($basepackages = any2array(hiera_array("basepackages")),
                     $unwantedpackages = any2array(hiera_array("unwantedpackages")),  
                     ) {

  package { $basepackages: ensure => present }
  package { $unwantedpackages: ensure => absent }

  include etckeeper
  include network
}
