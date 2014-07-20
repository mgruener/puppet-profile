class profile::puppetmaster (
  $use_puppetdb = true,
) {
  include puppet::master

  if $use_puppetdb == true {
    include puppetdb
    include puppetdb::master::config
  }
}
