maintainer        "Robert Choi"
maintainer_email  "taeilchoi1@gmail.com"
license           "Apache 2.0"
description       "KTC wrapper for collectd cookbook"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.0"

recipe            "default", ""
recipe            "default", "Install and configure collectd-client"

supports          "ubuntu", ">= 8.04"
supports          "debian", ">= 5.0"
supports          "fedora"
supports          "centos"
supports          "redhat"

depends           "collectd"
