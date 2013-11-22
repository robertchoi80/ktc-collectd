nova_api_processes = [
  { "name" => "nova-scheduler", "shortname" => "nova-scheduler" },
  { "name" => "nova-conductor", "shortname" => "nova-conductor" },
  { "name" => "nova-api-ec2", "shortname" => "nova-api-ec2" },
  { "name" => "nova-api-metadata", "shortname" => "nova-api-metada" },
  { "name" => "nova-api-os-compute", "shortname" => "nova-api-os-com" },
  { "name" => "nova-novncproxy", "shortname" => "nova-novncproxy" },
  { "name" => "nova-consoleauth", "shortname" => "nova-consoleaut" }
]

cinder_api_processes = [
  { "name" =>  "cinder-api", "shortname" =>  "cinder-api" },
  { "name" =>  "cinder-scheduler", "shortname" =>  "cinder-schedule" }
]

ktc_collectd_processes "nova-api-processes" do
  input nova_api_processes
end

ktc_collectd_processes "cinder-api-processes" do
  input cinder_api_processes
end

include_recipe "ktc-collectd::client_collectd"
