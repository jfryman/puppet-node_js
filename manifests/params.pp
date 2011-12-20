class node_js::params {
  case $::operatingsystem {
    debian: {
      $ns_packages = ['nodejs']
      $ns_apt_repo = 'deb http://ftp.us.debian.org/debian/ sid main'
      $ns_repo_ref = Apt::Repo['node-js']

      apt::repo { 'node-js':
        ensure       => 'present',
        type         => 'deb',
        uri          => 'http://ftp.us.debian.org/debian/',
        distribution => 'sid',
        components   => ['main'],
      }
    }
    ubuntu: {
      $ns_packages = ['nodejs', 'npm']
      $ns_repo_ref = Apt::Ppa['ppa:chris-lea/node.js']

      apt::ppa { 'ppa:chris-lea/node.js': }
    }
    redhat,centos,fedora,oel: {
      $ns_packages = ['nodejs', 'libicu', 'v8', 'npm']
      $ns_repo_ref = Yumrepo['nodejs-stable']

      yumrepo { 'nodejs-stable':
        enabled    => '1',
        descr      => 'Stable releases of Node.js',
        mirrorlist => 'http://nodejs.tchol.org/mirrors/nodejs-stable-el$releasever',
        gpgcheck   => '0',
      }
    }
  }
}
