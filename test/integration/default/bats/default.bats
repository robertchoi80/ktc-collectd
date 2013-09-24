# vim: ft=sh:
# only run on rhel
@test "should have collectd running" {
  [ "$(ps aux | grep collectd | grep -v grep)" ]
}

@test "check unix socket file" {
  [ "$(ls /var/lib/collectd/collectd.sock)" ]
}

@test "check forward to splunk script file" {
  [ "$(ls /usr/lib/collectd/splunk.rb)" ]
}

@test "check crontab for splunk.rb " {
  [ "$(crontab -l |grep splunk.rb)" ]
}
