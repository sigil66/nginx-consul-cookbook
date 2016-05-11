#
# Cookbook Name:: nginx-consul
# Recipe:: consul
#
# Copyright (C) 2016 Zachary Schneider
#
#

package 'consul' do
  options '-o Dpkg::Options::="--force-confold"'
end

file '/etc/consul/systemd.env' do
  content "OPTIONS=-server -bootstrap-expect 1 -client 0.0.0.0 -ui\n"
  mode 0644
  notifies :restart, "service[consul]"
end

service 'consul' do
  action [:enable, :start]
end
