class profile::virthost ($guests = hiera_hash("${module_name}::virthost::guests",undef)) {

  include virtualization

  if $guests != undef {
    create_resources('guest',$guests)
  }
}
