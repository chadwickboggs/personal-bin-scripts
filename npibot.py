#!/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python -O
# -*- coding: iso-8859-15 -*-
#
# A RPN calculator for Jabber.
# Copyright (C) 2011 MiKael NAVARRO
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

"""A RPN calculator for Jabber.
Copyright (C) 2011 MiKael NAVARRO

An unpretentious Jabber bot that performs RPN mathematical functions.

0. Create a Jabber server (ejabberd on localhost)
1. Launch this Python script & connect to server
2. From Jabber client (Gajim or jabber under Emacs) 
   connect to server & chat with npi 
3. Enter commands like '1 2 - 4 5 + *'

"""

# Specific variables for pydoc
__author__ = "MiKael Navarro <klnavarro@gmail.com>"
__date__ = "Wed Nov 30 2011"
__version__ = "0.1.0"
__credits__ = """Thanks to Nathan Fritz, author of SleekXMPP."""

# Include directives
import sys
import os
import logging
from pprint import pprint as pp

from sleekxmpp import ClientXMPP
from sleekxmpp.exceptions import IqError, IqTimeout

try:
    from npi import main as npi
except ImportError:
    srcdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), "../src")
    sys.path.append(srcdir)  # try to add ../src dir
    from npi import main as npi


#
# Bot class.
#
class NPIBot(ClientXMPP):
    """A simple NPI bot that will respond to messages it receives."""
    
    def __init__(self, jid, password):
        ClientXMPP.__init__(self, jid, password)
        logging.debug("Connect to %s..." % jid)

        # The session_start event will be triggered when
        # the bot establishes its connection with the server
        # and the XML streams are ready for use. We want to
        # listen for this event so that we we can initialize
        # our roster.
        self.add_event_handler("session_start", self.session_start)

        # The message event is triggered whenever a message
        # stanza is received. Be aware that that includes
        # MUC messages and error messages.
        self.add_event_handler("message", self.message)

        # Register plugins.
        # Note that while plugins may have interdependencies,
        # the order in which you register them does not matter.
        #self.register_plugin('xep_0030') # Service Discovery
        #self.register_plugin('xep_0004') # Data Forms
        #self.register_plugin('xep_0060') # PubSub
        #self.register_plugin('xep_0199') # XMPP Ping

        # If you are working with an OpenFire server, you will
        # need to use a different SSL version:
        #import ssl
        #self.ssl_version = ssl.PROTOCOL_SSLv3
        
        # If you want to verify the SSL certificates offered by a server:
        #self.ca_certs = "path/to/ca/cert"
        
    def session_start(self, event):
        self.send_presence()  # <presence />

        # Most get_*/set_* methods from plugins use Iq stanzas, which
        # can generate IqError and IqTimeout exceptions
        try:
            self.get_roster()
            #<iq type="get">
            #  <query xmlns="jabber:iq:roster" />
            #</iq>
            #
            #<iq type="result" to="echobot@example.com" from="example.com">
            #  <query xmlns="jabber:iq:roster">
            #    <item jid="friend@example.com" subscription="both" />
            #  </query>
            #</iq>
        except IqError as err:
            logging.error("There was an error getting the roster")
            logging.error(err.iq['error']['condition'])
            self.disconnect()
        except IqTimeout:
            logging.error("Server is taking too long to respond")
            self.disconnect()

    def message(self, msg):
        #<message to="echobot@example.com" from="someuser@example.net" type="chat">
        #  <body>Hej!</body>
        #</message>
        #
        #<message to="someuser@example.net" type="chat">
        #  <body>Thanks for sending: Hej!</body>
        #</message>
        if msg['type'] in ('chat', 'normal'):
            cmd = "%(body)s" % msg
            result = npi(cmd + ' q', False)
            if result != None:
                msg.reply("%s" % result).send()
            else:
                msg.reply("I don't understand '%s'" % cmd).send()


#
# Main entry point.
#
def main(options):
    """start/connect NPI bot."""

    # Loglevel
    loglevel = logging.ERROR  #logging.WARNING
    if options.debug:
        loglevel = logging.DEBUG
        
    logging.basicConfig(level=loglevel,
                        format='%(levelname)-8s %(message)s')

    # Start/connect to the XMPP server and start processing XMPP stanzas.
    xmpp = NPIBot(options.jid, options.password)
    if xmpp.connect():
        # If you do not have the dnspython library installed, you will need
        # to manually specify the name of the server if it does not match
        # the one in the JID. For example, to use Google Talk you would
        # need to use:
        #
        # if xmpp.connect(('talk.google.com', 5222)):
        #     ...
        xmpp.process(block=True)
        logging.debug("Done.")
    else:
        logging.debug("Unable to connect!")


#
# External entry point.
#
if __name__ == '__main__':
    # Get options
    from optparse import OptionParser, make_option

    option_list = [
        make_option("-j", "--jid",
                    action="store", dest="jid", 
                    type="string", default="npi@localhost",
                    help="NPI bot Jabber ID"),
        make_option("-p", "--password",
                    action="store", dest="password", 
                    type="string", default="npibot",
                    help="NPI bot password"),
        make_option("-d", "--debug",
                    action="store_true", dest="debug", 
                    default=False,
                    help="toggle traces"),
        ]

    parser = OptionParser(usage="python -O %prog [options]", 
                          version=__version__,
                          description="An unpretentious Jabber bot that performs RPN mathematical functions.",
                          option_list=option_list)

    (options, args) = parser.parse_args()

    # Process start here
    main(options)
