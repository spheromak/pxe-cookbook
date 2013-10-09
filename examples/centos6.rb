# Author:: Jesse Nelson <spheromak@gmail.com>
# Cookbook Name:: pxe
# Recipe:: redhat
#

repo_server = node[:repo_server]
include_recipe "tftp::server"

tftp_dir = node[:tftp][:dir]
dist = "centos/6"

directory "/tftpboot/#{dist}" do
  recursive true
end

{ "initrd.img" => "dc275513",
     "vmlinuz" => "9c6e39c8",
  }.each do |file,hash|
  remote_file "/tftpboot/#{dist}/#{file}" do
    source "http://#{repo_server}/prod/centos/6/os/x86_64/images/pxeboot/#{file}"
    mode "0644"
    checksum hash
    not_if  { File.exists?("#{tftp_dir}/#{dist}/#{file}") }
  end
end

pxe_menu "centos-6" do
  section "centos"
  default true
  label "CentOS 6 Auto Kickstart"
  kernel "#{dist}/vmlinuz"
  initrd "#{dist}/initrd.img"
  append "ramdisk_size=16000 ks=http://#{repo_server}/prod/ks/default.ks ksdevice=bootif"
end

pxe_menu "centos-6-manual" do
  section "centos"
  label "CentOS 6 Manual"
  kernel "#{dist}/vmlinuz"
  initrd "#{dist}/initrd.img"
  append "ramdisk_size=16000"
end
