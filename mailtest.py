#!/usr/bin/env python3
####################################################################
# TRMurphy
# mailtest.py
#
# sends python email test program
####################################################################

import subprocess
import smtplib
import socket
import glob
import os



hostname=socket.gethostname()
maillist="trmurphy@emailaddress.com"


########################################
# send email
########################################
def sendemail():
    FROM="thomas.murphy@stonex.com"
    TO="thomas.murphy@stonex.com"
    SERVER="SMTP_SERVER_IP_ADDRESS_GOES_HERE"
    SUBJECT="mailstuff: "+hostname+""
    TEXT="test email\n\n"


    message = 'Subject: {}\n\n{}'.format(SUBJECT, TEXT)

    try:
        server = smtplib.SMTP(SERVER)
        server.sendmail(FROM, TO, message)
        server.quit()
    except:
        print("smtp exception happened")



# main


sendemail()

exit(0)
