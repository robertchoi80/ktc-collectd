#
# Cookbook Name:: ktc-collectd
# Recipe:: client_collectd
#

include_recipe 'collectd::client'

servers = []

if Chef::Config[:solo]
  if node['collectd']['server_address'].nil?
    servers << '127.0.0.1'
  else
    servers << node['collectd']['server_address']
  end
else
  query = "recipes:#{node['collectd']['server_recipe']} AND chef_environment:#{node.chef_environment}"
  search(:node, query) do |n|
    servers << n['fqdn']
  end
end

collectd_plugin "network" do
  options :server => servers
  type 'plugin'
end

collectd_plugin "cpu"
collectd_plugin "memory"
collectd_plugin "load"
collectd_plugin "df"
collectd_plugin "disk"
collectd_plugin "swap"
collectd_plugin "interface"
collectd_plugin "ping"
collectd_plugin "uptime"
collectd_plugin "process"
