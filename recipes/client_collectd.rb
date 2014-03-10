#
# Cookbook Name:: ktc-collectd
# Recipe:: client_collectd
#

chef_gem 'chef-rewind'
require 'chef/rewind'

package 'collectd-core' do
  version node['collectd']['version']
  options node['collectd']['install_options']
end

include_recipe 'collectd::client'

rewind package: 'collectd' do
  version node['collectd']['version']
  options node['collectd']['install_options']
end

servers = []

if Chef::Config[:solo]
  if node['collectd']['server_address'].nil?
    servers << '127.0.0.1'
  else
    servers << node['collectd']['server_address']
  end
else
  query = "recipes:#{node['collectd']['server_recipe']} "
  query << "AND chef_environment:#{node.chef_environment}"
  search(:node, query) do |n|
    servers << n['fqdn']
  end
end

collectd_plugin 'network' do
  options server: servers
  type 'plugin'
end

template '/etc/collectd/plugins/processes.conf' do
  source 'processes.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :nothing
end

accumulator 'collectd_process_accumulator' do
  target template: '/etc/collectd/plugins/processes.conf'
  filter { |res| res.is_a? Chef::Resource::KtcCollectdProcesses }
  transform do|resources|
    all_processes = Array.new
    resources.each do |r|
      ret_arr = KTC::Helpers.select_and_strip_keys r.input, 'shortname'
      all_processes.concat(ret_arr)
    end
    all_processes
  end
  variable_name :all_processes
end

collectd_plugin 'cpu'
collectd_plugin 'memory'
collectd_plugin 'load'
collectd_plugin 'df'
collectd_plugin 'disk'
collectd_plugin 'interface'
collectd_plugin 'uptime'
