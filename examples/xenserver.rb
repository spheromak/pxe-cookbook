# Author:: Jesse Nelson <spheromak@gmail.com>
# Cookbook Name:: pxe
# Recipe:: xenserver
#


repo_server = node[:repo_server]

include_recipe "pxe::default"
include_recipe "tftp::server"

# were are we looking for tftp files
tftp_dir = node[:tftp][:dir]
dist = "xenserver/6"

directory  "#{tftp_dir}/#{dist}" do
    recursive true
end

# 3. From the XenServer installation media, copy the files install.img (from the root directory), vmlinuz
# and xen.gz (from the /boot directory) to the new /tftpboot/xenserver directory on the TFTP
# server.
%w{vmlinuz xen.gz}.each do |file|
  remote_file "#{tftp_dir}/#{dist}/#{file}"  do
    mode 0644
    source "http://#{repo_server}/prod/xenserver/6/boot/#{file}"
    not_if  { File.exists?("#{tftp_dir}/#{dist}/#{file}") }
  end
end

remote_file "#{tftp_dir}/#{dist}/install.img" do
  mode 0644
  source "http://#{repo_server}/prod/xenserver/6/install.img"
  not_if  { File.exists?("#{tftp_dir}/#{dist}/install.img") }
end

pxe_menu "xenserver-6" do
  section "xenserver"
  default true
  label  "Xenserver 6 Auto"
  kernel "mboot.c32"
  append "xenserver/6/xen.gz dom0_max_vcpus=2 dom0_mem=2752M --- xenserver/6/vmlinuz answerfile=http://#{repo_server}/prod/ks/xs/answerfile answerfile_device=eth0 install --- xenserver/6/install.img"
end

pxe_menu "xenserver-6-manual" do
  section "xenserver"
  label  "Xenserver 6 Manual"
  kernel "mboot.c32"
  append "xenserver/6/xen.gz dom0_max_vcpus=2 dom0_mem=2752M --- xenserver/6/vmlinuz --- xenserver/6/install.img"
end
