#
# vim: set ft=ruby:
#
site :opscode

metadata

cookbook 'collectd', github: 'miah/chef-collectd'
cookbook "graphite", github: "hw-cookbooks/graphite"

# solo-search for intgration tests
group :integration do
  cookbook 'chef-solo-search', github: 'edelight/chef-solo-search'

# add in a test cook for minitest or to twiddle an LWRP
#  cookbook 'my_cook_test', :path => './test/cookbooks/my_cook_test'
end
