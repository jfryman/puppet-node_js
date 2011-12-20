class node_js::package {
  package { $node_js::params::ns_packages: 
    ensure  => present, 
  }
}
