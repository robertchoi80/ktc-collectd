include_recipe "ktc-collectd::client_collectd"

processes = [
  { "name" => "nova-compute-long", "shortname" => "nova-compute" },
  { "name" => "libvirt-long", "shortname" => "libvirt" }
]

collectd_processes "compute-processes" do
  input processes
  key "shortname"
end
