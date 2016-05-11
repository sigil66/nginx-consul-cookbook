#
# Cookbook Name:: nginx-consul
# Recipe:: default
#
# Copyright (C) 2016 Zachary Schneider
#
#

include_recipe "sigil66::default"
include_recipe "sigil66::vagrant"
include_recipe "nginx-consul::consul"
include_recipe "nginx-consul::nginx"
include_recipe "nginx-consul::vertx"
