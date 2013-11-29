#
# Cookbook Name:: ktc-collectd
# Attributes:: default
#
# Copyright 2013, Robert Choi
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

include_attribute "collectd"

default['collectd']['version'] = "4.10.1"
default['collectd']['server_recipe'] = "ktc-monitor\\:\\:server_collectd"
default['collectd']['interval'] = 60
default['collectd']['processes_interval'] = 20
default['collectd']['read_threads'] = 10
