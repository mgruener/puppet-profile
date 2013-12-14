class profile::virthost ($guests = hiera_hash("${module_name}::virthost::guests",undef)) {

  include virtualization

  if $packages != undef {
    create_resources('guest',$guests)
  }
}
