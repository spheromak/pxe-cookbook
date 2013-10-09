#
# Author:: Jesse Nelson <spheromak@gmail.com>
# Cookbook Name:: pxe
# Recipe:: ubuntu
#

include_recipe "tftp::server"
include_recipe "pxe::default"

directory "/tftpboot/ubuntu"

include_recipe "pxe::precise"
