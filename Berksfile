#
# vim: set ft=ruby:
#

chef_api "https://chefdev.mkd2.ktc", node_name: "cookbook", client_key: ".cookbook.pem"

site :opscode

metadata

cookbook 'collectd', github: 'miah/chef-collectd'
cookbook "graphite", github: "hw-cookbooks/graphite"

cookbook "ktc-testing"
#cookbook 'chef-solo-search', github: 'edelight/chef-solo-search'
