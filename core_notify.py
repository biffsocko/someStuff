#!/usr/bin/env python3
############################################################################################
# TR Murphy
# core_notify.py
#
# uses the kernel inotify facility.  It monitors a directory for the creation of a new file.
# for more information on this facility READ: https://lwn.net/Articles/760714/
#
#
# NOTE: because this uses kernel facilities, it will not work on mounted
# filesystems.
#
# requires pyinotify, dirsync and pymstreams to be installed
#
# Instructions for the crash file:
#  1) apport-unpack systemGeneratedCrashReportPath.crash yourNewUnpackDirectoryHere
#  2) cd yourNewUnpackDirectoryHere/
#  3) gdb `cat ExecutablePath` CoreDump (pay attention to backticks here!)
#  4) bt (output actual back-trace)
############################################################################################

import os
import sys
import time
import pyinotify
import pymsteams
from dirsync import sync

########################################
# variables
########################################
directory_to_watch = '/var/crash'
# valid webhook for pascal war room channel
webhookurl="https://intlfcstone.webhook.office.com/webhookb2/a0ae8289-3917-441f-a9fe-356652fd619d@d1bdddc1-de7b-4a77-914e-213d203667f2/IncomingWebhook/cda8e7dc7c494adf8f173f814fdb5dcd/cf7cb2e8-d857-424f-9700-516f06c11637"
debug=0
target_path = '/data/crash'


# handle events
class EventHandler(pyinotify.ProcessEvent):
    def process_IN_CLOSE_WRITE(self, event):

       # default message
       message="<h2>ALERT - PROD COREDUMP CREATED</h2><br><pre>coredump files created on pascal prod1 and preserved in /data/crash</pre>"
        ##################################################################
        # this is where the stuff happens.  Anything you want to do will
        # probably go here
        # This method will be triggered when a file is closed after writing
        # this would be the place to add your own functionality.
        ##################################################################

       # create and sync data to the target directory if it doesn't exist
       try:
         if not os.path.exists(target_path):
           os.makedirs(target_path)
         sync(directory_to_watch, target_path, 'sync')
       except Exception:
           message="<h2>ALERT - PROD COREDUMP CREATED</h2><br><pre>coredump files NOT created on pascal prod1</pre>"


       # send the alert to the teams channel
       if(debug > 0 ):
         # left here for testing and not sending alerts to the whole channel
         print("coredump files created on prod1 pascal:", event.pathname)
       else:
         myTeamsMessage = pymsteams.connectorcard(webhookurl)
         myTeamsMessage.text(message)
         myTeamsMessage.send()



# Initialize the WatchManager and EventHandler
wm = pyinotify.WatchManager()
handler = EventHandler()

# Define the events to monitor
mask = pyinotify.IN_CLOSE_WRITE

# Add the directory to the watch list
try:
    wm.add_watch(directory_to_watch, mask, rec=True)
except e :
    print(e)

# Initialize the Notifier with the WatchManager and EventHandler
notifier = pyinotify.Notifier(wm, handler)

# Start the event loop
while True:
    try:
        # Process any events and update the status
        notifier.process_events()
        if notifier.check_events():
            notifier.read_events()
    except KeyboardInterrupt:
        # Terminate the event loop when interrupted
        notifier.stop()
        break
