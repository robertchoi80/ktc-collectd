maintainer        "Robert Choi"
maintainer_email  "taeilchoi1@gmail.com"
license           "Apache 2.0"
description       "KTC wrapper for collectd cookbook"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.0"

recipe            "default", ""
recipe            "client_collectd", "Install and configure collectd-client"
recipe            "client_graphite", "configure graphite plugin"

supports          "ubuntu" 
supports          "debian"
supports          "fedora"
supports          "centos"
supports          "redhat"

depends           "collectd"
