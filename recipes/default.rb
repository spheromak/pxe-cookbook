# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: pxe_dust
# Recipe:: default
#
# Copyright 2011, Opscode, Inc
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


include_recipe 'tftp::server'

tftp_dir = node[:tftp][:dir]
syslinux_dir = node[:syslinux][:dir]

node[:pxe][:packages].each do |pkg|
  package pkg
end

# setup root pxelinux and config dir
%w/pxelinux.0 menu.c32 mboot.c32/.each do |booter|
  execute  "cp #{syslinux_dir}#{booter} #{tftp_dir}/#{booter}"  do
    action :run
    not_if {File.exists?("#{tftp_dir}/#{booter}")}
  end
end

directory "#{tftp_dir}/pxelinux.cfg" do
  mode 0755
end

template "#{node[:tftp][:dir]}/pxe.cfg" do
  mode 0644
end
