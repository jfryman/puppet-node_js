class node_js {
  include stdlib
  include node_js::params

  anchor { 'node_js::begin': }
  -> class { 'node_js::package': }
  -> class { 'node_js::config': }
  -> class { 'node_js::service': }
  -> anchor { 'node_js::end:': }
}
