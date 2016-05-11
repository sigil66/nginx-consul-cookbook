#
# Cookbook Name:: nginx-consul
# Recipe:: nginx
#
# Copyright (C) 2016 Zachary Schneider
#
#

package 'openresty'
package 'lua-cjson'

package 'nginx-extras' do
  options '-o Dpkg::Options::="--force-confold"'
end

directory '/etc/nginx/lua/consul' do
  mode 0755
  recursive true
end

cookbook_file '/etc/nginx/lua/consul/balancer.lua' do
  source 'balancer.lua'
  mode 644
  notifies :restart, 'service[nginx]'
end

template '/etc/nginx/sites-available/default' do
  source 'nginx-default.erb'
  mode 0644
  notifies :restart, 'service[nginx]'
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  mode 0644
end

template '/var/www/html/500.html' do
  source '500.html.erb'
  mode 0644
end

template '/var/www/html/503.html' do
  source '503.html.erb'
  mode 0644
end

service 'nginx' do
  action [:enable, :start]
end
