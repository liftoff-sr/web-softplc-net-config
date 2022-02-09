# SoftPLC Network Configuration Web UI

This repo uses CMake to build a *.deb file that is a debian package for a
SoftPLC Runtime.  Busybox httpd is used along with its CGI support to call
a bash script to modify the fields:

address
netmask
gateway

in a file similar to /etc/network/interfaces

Basically it simply changes those 3 fields and provides for an IP address change.

It also serves as an example for those who want to extend it to add more features
in support of TLMs or application specific customizations that require their own
configuration edits.




