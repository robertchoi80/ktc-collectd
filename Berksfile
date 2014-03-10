#
# vim: set ft=ruby:
#

chef_api "https://chefdev.mkd2.ktc", node_name: "cookbook", client_key: ".cookbook.pem"

site :opscode

metadata

cookbook "accumulator"

group "integration" do
  cookbook "ktc-testing"
  cookbook "ktc-graphite"
  cookbook "collectd_test", path: "test/cookbooks/collectd_test"
end
