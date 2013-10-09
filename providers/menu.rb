# 
# menu entry provider for pxeboot
#
#

def write_default
  pxe_entries = Hash.new
  pxe_default = Hash.new
  pxe_sections = Array.new
  
  run_context.resource_collection.each do |resource|
  if resource.is_a? Chef::Resource::PxeMenu and
    resource.action == :add and
    resource.add_to_default == true
    pxe_entries[resource.section] ||= Array.new
    pxe_sections << resource.section 
      
    pxe_default[resource.section] ||= ""
    if resource.default == true
      pxe_default[resource.section] = resource.name
    end

    if resource.section == new_resource.section
      pxe_entries[resource.section] << resource.name
    end

   end
  end

  pxe_sections.uniq!

  # build section menu
  template "#{node[:tftp][:dir]}/#{new_resource.section}/pxelinux.cfg/default" do
    source "default.erb"
    cookbook "pxe"
    owner "root"
    group "root"
    mode 0644 
    variables( 
      :default => pxe_default[new_resource.section] ,
      :includes => pxe_entries 
    )
    notifies :send_notification, new_resource, :immediately
  end

  #  write main menu
  template "#{node[:tftp][:dir]}/pxelinux.cfg/default" do
    source "main.erb"
    cookbook "pxe"
    owner "root"
    group "root"
    mode 0644
    variables( :sections => pxe_sections ) 
    notifies :send_notification, new_resource, :immediately
  end
end


action :add do
  directory "#{node[:tftp][:dir]}/#{new_resource.section}/pxelinux.cfg" do
    recursive true
    owner "root"
    group "root"
    notifies :send_notification, new_resource, :immediately
  end

  append = ""
  unless new_resource.initrd.empty?
    append << " initrd=#{new_resource.initrd} " 
  end

  unless new_resource.append.empty?
    append << new_resource.append 
  end 

  template "#{node[:tftp][:dir]}/#{new_resource.section}/pxelinux.cfg/#{new_resource.name}" do
    source "menu_item.erb"
    cookbook "pxe"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name => new_resource.name,
      :append => append,
      :label => new_resource.label,
      :kernel => new_resource.kernel,
      :command => new_resource.command,
      :single_entry => new_resource.single_entry
    )
    
    notifies :send_notification, new_resource, :immediately
  end

  write_default if new_resource.add_to_default
end


action :remove do 
  file "#{node[:tftp][:dir]}/#{new_resource.section}/pxelinux.cfg/#{new_resource.name}" do
    action :delete
    notifies :send_notification, new_resource, :immediately
  end

  # rebuild the main menu
  write_default
end

action :send_notification do
  new_resource.updated_by_last_action(true)
end
