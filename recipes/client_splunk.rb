#
# Cookbook Name:: ktc-collectd
# Recipe:: client_splunk
#
# Copyright 2013, Sunhee Ahn.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'collectd::client'

collectd_plugin "unixsock" do
  options ({ :SocketFile => "/var/lib/collectd/collectd.sock",
    :SocketGroup => "collectd",
    :SocketPerms => "0770"
  })
  type 'plugin'
end

cookbook_file 'splunk_rb' do
  source 'splunk.rb'
  path   "#{ node['collectd']['plugin_dir'] }/splunk.rb"
  owner  'root'
  group  'root'
  mode   0755
end

if node.has_key?('monitoring') and node['monitoring'].has_key?('splunk')
  cron 'splunk_cron' do
    minute "*/2"
    command "#{ node['collectd']['plugin_dir'] }/splunk.rb #{ node['monitoring']['splunk']['ip'] } #{ node['monitoring']['splunk']['port'] } >/dev/null 2>&1"
    action :create
  end
end
