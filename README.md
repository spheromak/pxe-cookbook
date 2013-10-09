Description
===========
Cookbook & LWRP for generating PXE config and Menus on ubuntu/centos

pxe_menu LWRP
=====

## Options
### section, (string) default:  ""
  The sub-section this entry belongs too i.e. "ubuntu" 
### label,  (string)   required 
  The descriptive label of this entry 
### kernel, (string) default: ""
  The path to the kernel file
### initrd, (string) default: ""
  The path to the initrd
### append, (string) default: ""
  Extra info to append to the boot command
### command, (string) default: ""
  Addtional pxelinux command to add 
### default, (bool) default: false
  Make this entry default for this section. Takes the last-seen default 
### add_default, (bool) default: true
  add this entry in the section default

Usage
=====

  see the various recipes for examples 
  
Requirements
============

Requires Chef 0.10.0+.

## Platform:

Tested on:

* Centos
* Ubuntu

## Cookbooks:

Required: tftp


