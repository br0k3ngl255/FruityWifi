#!/usr/bin/env python

#	Copyright (C) 2013-2014  xtr4nge [_AT_] gmail.com
#	edited  by br0k3ngl255
 
import sys, getopt

import urllib2
from xml.dom.minidom import parse
from xml.dom import Node

from pprint import pprint

import subprocess, os

# get FruityWifi version
cmd = "cat /usr/share/FruityWifi/www/config/config.php |grep version"
f = os.popen(cmd)
output = f.read()
version = str(output).replace('\n','').replace('$version="v','').replace('";','')

url = urllib2.urlopen("https://raw.githubusercontent.com/xtr4nge/FruityWifi/master/modules-FruityWifi.xml")
dom = parse( url )

for modules in dom.getElementsByTagName('module'):
	
	info = {
			'name':         '',
			'version':      '',
			'author':       '',
			'description':  '',
			'url':          '',
			'required':     '',
		}
	
	for item in modules.childNodes:
		
		if item.nodeName == "name":
			info['name'] = item.childNodes[0].nodeValue
		
		if item.nodeName == "version":
			info['version'] = item.childNodes[0].nodeValue
			
		if item.nodeName == "author":
			info['author'] = item.childNodes[0].nodeValue
			
		if item.nodeName == "description":
			info['description'] = item.childNodes[0].nodeValue
			
		if item.nodeName == "url":
			info['url'] = item.childNodes[0].nodeValue
		
		if item.nodeName == "required":
			info['required'] = item.childNodes[0].nodeValue
	
	# Install module
	if (float(version)) >= float(info['required']):
		print info['name'] + " v" + info['version']
		cmd_install = "git clone https://github.com/xtr4nge/module_"+info['name']+".git /usr/share/FruityWifi/www/modules/"+info['name']
		print cmd_install
		os.system(cmd_install)
		cmd_install = "cd /usr/share/FruityWifi/www/modules/"+info['name']+"/includes/; ./install.sh"
		os.system(cmd_install)
		print
	else: 
		print "Module " + info['name'] + " requires FruityWifi >= v" + info['required']
