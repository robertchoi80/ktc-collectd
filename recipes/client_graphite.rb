#
# Cookbook Name:: ktc-collectd
# Recipe:: client_graphite
#
# Copyright 2013, Robert Choi.
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

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "services"

endpoint = Services::Endpoint.new "graphite"
endpoint.load

include_recipe "collectd::client_graphite"

# Rewind the plugin to enable store_rates option
if node['collectd']['version'] =~ /5\.\d+/
  rewind :collectd_plugin => 'write_graphite' do
    options({
      :host => endpoint.ip,
      :port => 2003,
      :prefix => node['collectd']['graphite_prefix'],
      :escape_character => "_",
      :store_rates => true
    })
  end
else
  rewind :collectd_plugin => 'carbon_writer' do
      template "python_conf_new.erb"
      cookbook_name "ktc-collectd"
  end
end
