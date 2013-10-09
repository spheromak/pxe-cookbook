# default thing to install
#  should be a better wway
default[:pxe][:default] = "ubuntu-precise"
default[:syslinux][:dir] = "/usr/share/syslinux/"

case node[:platform_family]
when "rhel"
  default[:pxe][:packages] = ["system-config-netboot-cmd", "syslinux"]
  default[:syslinux][:dir] = "/usr/share/syslinux/"
when "debian"
  default[:pxe][:packages] = ["syslinux-common"]
  default[:syslinux][:dir] = "/usr/lib/syslinux/"
end
