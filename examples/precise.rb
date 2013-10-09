# Author:: Jesse Nelson <spheromak@gmail.com>
# Cookbook Name:: pxe
# Recipe:: redhat
#

repo_server = node[:repo_server]

include_recipe "pxe::default"
include_recipe "tftp::server"

tftp_dir = node[:tftp][:dir]
dist = "ubuntu/precise"

# were are we looking for tftp files
directory  "#{tftp_dir}/#{dist}" do
  recursive true
end

{
  "linux" => "ec12ab2c89c1420f3362ebba47ddd23b",
  "initrd.gz" => "73566c73568eacfaf07ef3568ebe3e64",
}.each do |file,hash|
  remote_file "#{tftp_dir}/#{dist}/#{file}" do
    source "http://#{repo_server}/prod/ubuntu/dists/precise/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/#{file}"
    mode "0644"
    checksum hash
    not_if  { File.exists?("#{tftp_dir}/#{dist}/#{file}") }
  end
end

precise_auto_append ="auto=true priority=critical netcfg/chooseinterface=auto  url=http://#{ repo_server }/prod/ks/precise.cfg  DEBCONF_INTERFACE=noninteractive base-installer/install-recommends=false "
pxe_menu "ubuntu-precise" do
  section "ubuntu"
  default true
  label  "Ubuntu 12.04 (precise) Preseed"
  kernel "#{dist}/linux"
  initrd "#{dist}/initrd.gz"
  append precise_auto_append
  command "IPAPPEND 2"
end

pxe_menu "ubuntu-precise-manual" do
  section "ubuntu"
  kernel "#{dist}/linux"
  initrd "#{dist}/initrd.gz"
  label "Ubuntu 12.04 (precise) Manual"
end

#
# setup a proc  for adding mac entries
#
precise_auto = Proc.new do
  single_entry true
  add_to_default false
  default true
  label  "Ubuntu 12.04 (precise) Preseed"
  kernel "#{dist}/linux"
  initrd "#{dist}/initrd.gz"
  append precise_auto_append
  command "IPAPPEND 2"
end

#
# Load group hosts and generate mac-pxe configs
#  Generate mac files defaulting to this def
#
unless node[:pxe][:groups_bag].empty?
  search( node[:pxe][:groups_bag], "pxe:ubuntu-precise" ) do |group|
    group['hosts'].each do |host, data|
      next unless data.has_key? "mac"
      pxe_menu mac_to_pxe(data['mac']), &precise_auto
    end
  end
end

#
#  loop through host bags
#  Generate mac files defaulting to this def
#
unless node[:pxe][:hosts_bag].empty?
  search( node[:pxe][:hosts_bag], "pxe:ubuntu-precise").each do |host|
    unless host.has_key? "mac"
      Chef::Log.warn "Bag #{node[:pxe][:hosts_bag]}/#{host[:id]} has pxe entry, but no 'mac' key"
      next
    end

    pxe_menu mac_to_pxe(host['mac']), &precise_auto
  end
end

