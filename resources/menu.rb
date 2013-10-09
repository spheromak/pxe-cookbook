#
#  PXE menu entry LWRP
#  Author:: Jesse Nelson <spheromak@gmail.com>
#
actions :add, :remove, :send_notification 
default_action :add

attribute :name, :kind_of => String, :name_attribute => true 
attribute :section, :kind_of => String, :default => ""
attribute :label, :kind_of => String 
attribute :kernel, :kind_of => String, :default => ""
attribute :initrd, :kind_of => String, :default => ""
attribute :append, :kind_of => String, :default => ""
attribute :command, :kind_of => String, :default => ""
attribute :default, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :add_to_default, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :single_entry, :kind_of => [ TrueClass, FalseClass ], :default => false
