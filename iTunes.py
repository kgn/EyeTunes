#!/usr/bin/env python

# Update the AppleScript information for iTunes

from __future__ import with_statement

import os
import plistlib
import subprocess
import xml.dom.minidom

k_iTunesApp = '/Applications/iTunes.app'
k_iTunesDir = os.path.abspath('./iTunes')

def GetVersion():
    '''Get the current iTunes version'''
    infoPlist = os.path.join(k_iTunesApp, 'Contents', 'Info.plist')
    return plistlib.readPlist(infoPlist)['CFBundleVersion']

def SaveSdef(output):
    '''Save the iTunes sdef xml to disk'''
    proc = subprocess.Popen('sdef %s' % k_iTunesApp, shell=True, 
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    stdout, stderr = proc.communicate()
    if stderr:
        raise RuntimeError(stderr)
    dom = xml.dom.minidom.parseString(stdout.strip())
    with open(output, 'w') as file:
        file.write(dom.toprettyxml(encoding='utf-8'))
        
def SaveHeader(output):       
    '''Save the iTunes header file to disk''' 
    proc = subprocess.Popen('sdef %s | sdp -fh --basename iTunes -o "%s"' % (k_iTunesApp, output), 
        shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    stdout, stderr = proc.communicate()
    if stderr:
        raise RuntimeError(stderr)
        
if __name__ == '__main__':
    version = GetVersion()
    basename = 'iTunes_%s' % version
    SaveHeader(os.path.join(k_iTunesDir, '%s.h' % basename))    
    SaveSdef(os.path.join(k_iTunesDir, '%s_aete0.sdef' % basename))
