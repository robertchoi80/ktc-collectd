# vim: ft=sh:
# only run on rhel
@test "should have collectd running" {
  [ "$(ps aux | grep collectd | grep -v grep)" ]
}

@test "collectd should be listening for connections" {
  [ "$(netstat -nlp | grep collectd)" ]
}
