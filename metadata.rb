name             "pxe"
maintainer       "Jesse Nelson"
maintainer_email "spheromak@gmail.com"
description      "Redhat pxeos/pxeboot/netboot management"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.1"

%w{ centos rhel ubuntu }.each do |os|
  supports os
end

depends "tftp"
